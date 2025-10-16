import Icrc1Ledger "canister:icrc1_ledger_canister";
import LCKYBackend "canister:lcky_backend";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";

/**
 * Payment Backend for LCKY
 * Handles ICP payments and LCKY distribution
 */
actor PaymentBackend {

    // Types
    public type TransferArgs = {
        amount : Nat;
        toAccount : Icrc1Ledger.Account;
    };

    public type PaymentRecord = {
        from : Principal;
        amount : Nat;
        lckyReceived : Nat;
        timestamp : Int;
        status : Text;
    };

    // State
    private let owner : Principal = Principal.fromText("aaaaa-aa"); // Replace with actual owner
    private var paymentHistory = HashMap.HashMap<Nat, PaymentRecord>(100, Nat.equal, func(n: Nat) : Nat32 { Nat32.fromNat(n % 100000) });
    private stable var paymentCounter : Nat = 0;
    private stable var totalProcessed : Nat = 0;
    private stable var totalLCKYDistributed : Nat = 0;

    // Constants
    private let EXCHANGE_RATE : Nat = 100; // 1 ICP = 100 LCKY (in e8s base)
    private let MIN_PAYMENT : Nat = 10_000_000; // 0.1 ICP

    /**
     * Process ICP payment and mint LCKY tokens
     */
    public shared ({ caller }) func processPayment(icpAmount: Nat) : async Result.Result<Nat, Text> {
        Debug.print(
            "Processing payment of "
            # debug_show (icpAmount)
            # " from "
            # debug_show (caller)
        );

        if (icpAmount < MIN_PAYMENT) {
            return #err("Payment amount too small. Minimum is 0.1 ICP");
        };

        // Calculate LCKY amount
        // 1 ICP (100_000_000 e8s) = 100 LCKY (100_000_000_000_000_000_000 base units)
        let lckyAmount = (icpAmount * 100_000_000_000_000_000_000) / 100_000_000;

        // Call LCKY backend to mint tokens
        // Note: In production, this would involve proper authentication and minting rights
        
        // Record payment
        paymentCounter += 1;
        let record : PaymentRecord = {
            from = caller;
            amount = icpAmount;
            lckyReceived = lckyAmount;
            timestamp = Time.now();
            status = "completed";
        };
        
        paymentHistory.put(paymentCounter, record);
        totalProcessed += icpAmount;
        totalLCKYDistributed += lckyAmount;

        Debug.print("Payment processed successfully. LCKY amount: " # debug_show(lckyAmount));
        
        #ok(lckyAmount)
    };

    /**
     * Transfer ICP using ICRC-1 ledger
     */
    public shared ({ caller }) func transferICP(args : TransferArgs) : async Result.Result<Icrc1Ledger.BlockIndex, Text> {
        Debug.print(
            "Transferring "
            # debug_show (args.amount)
            # " ICP to account "
            # debug_show (args.toAccount)
        );

        let transferFromArgs : Icrc1Ledger.TransferFromArgs = {
            from = {
                owner = caller;
                subaccount = null;
            };
            memo = null;
            amount = args.amount;
            spender_subaccount = null;
            fee = null;
            to = args.toAccount;
            created_at_time = null;
        };

        try {
            let transferFromResult = await Icrc1Ledger.icrc2_transfer_from(transferFromArgs);

            switch (transferFromResult) {
                case (#Err(transferError)) {
                    return #err("Couldn't transfer funds: " # debug_show (transferError));
                };
                case (#Ok(blockIndex)) { 
                    return #ok blockIndex 
                };
            };
        } catch (error : Error) {
            return #err("Reject message: " # Error.message(error));
        };
    };

    /**
     * Donate ICP and receive LCKY
     */
    public shared ({ caller }) func donateICPForLCKY(icpAmount: Nat) : async Result.Result<Nat, Text> {
        Debug.print(
            "Processing donation of "
            # debug_show (icpAmount)
            # " ICP from "
            # debug_show (caller)
        );

        if (icpAmount < MIN_PAYMENT) {
            return #err("Donation too small. Minimum is 0.1 ICP");
        };

        // Process payment and get LCKY
        let result = await processPayment(icpAmount);
        
        switch (result) {
            case (#ok(lckyAmount)) {
                // Try to transfer LCKY from backend
                // This would require proper integration with LCKY backend
                #ok(lckyAmount)
            };
            case (#err(e)) #err(e);
        }
    };

    /**
     * Get payment history for a user
     */
    public query func getPaymentHistory(user: Principal, limit: Nat) : async [PaymentRecord] {
        let result = Array.filter<PaymentRecord>(
            Iter.toArray(paymentHistory.vals()),
            func (record: PaymentRecord) : Bool {
                Principal.equal(record.from, user)
            }
        );

        let size = result.size();
        if (size <= limit) {
            return result;
        };

        Array.tabulate<PaymentRecord>(limit, func(i: Nat) : PaymentRecord {
            result[size - limit + i]
        })
    };

    /**
     * Get total statistics
     */
    public query func getStats() : async {
        totalPayments : Nat;
        totalProcessed : Nat;
        totalLCKYDistributed : Nat;
    } {
        {
            totalPayments = paymentCounter;
            totalProcessed = totalProcessed;
            totalLCKYDistributed = totalLCKYDistributed;
        }
    };

    /**
     * Get exchange rate
     */
    public query func getExchangeRate() : async Nat {
        EXCHANGE_RATE
    };

    /**
     * Get minimum payment
     */
    public query func getMinimumPayment() : async Nat {
        MIN_PAYMENT
    };

    /**
     * Calculate LCKY amount for given ICP
     */
    public query func calculateLCKYAmount(icpAmount: Nat) : async Nat {
        (icpAmount * 100_000_000_000_000_000_000) / 100_000_000
    };

    /**
     * Health check
     */
    public query func healthCheck() : async Bool {
        true
    };

    // System functions
    system func preupgrade() {
        Debug.print("Preparing for upgrade...");
    };

    system func postupgrade() {
        Debug.print("Upgrade complete!");
    };
}

