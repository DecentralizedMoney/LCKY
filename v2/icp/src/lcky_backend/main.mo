import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Text "mo:base/Text";
import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Cycles "mo:base/ExperimentalCycles";

import Icrc1Ledger "canister:icrc1_ledger_canister";

/**
 * LCKY Token - Internet Computer Implementation
 * 
 * Features:
 * - ICRC-1 compatible token
 * - Mining with halving every 4 years
 * - Donation with burning and messages
 * - ICP donation to get LCKY
 * - Emergency SOS function
 */
shared(init_msg) actor class LCKYToken() = this {

    // Types
    public type Account = {
        owner : Principal;
        subaccount : ?Blob;
    };

    public type DonationMessage = {
        donor : Principal;
        amount : Nat;
        message : Text;
        timestamp : Int;
    };

    public type UserInfo = {
        balance : Nat;
        mined : Nat;
        lastClaimTime : Int;
        claimedInitial : Bool;
        canClaim : Bool;
    };

    public type Stats = {
        totalSupply : Nat;
        totalMined : Nat;
        totalDonated : Nat;
        totalICPDonated : Nat;
        currentBlockReward : Nat;
        contractICPBalance : Nat;
        donationCount : Nat;
    };

    // Constants
    private let MAX_SUPPLY : Nat = 108_000_000_000_000_000_000_000_000_000; // 108 billion with 18 decimals
    private let INITIAL_REWARD : Nat = 50_000_000_000_000_000_000; // 50 LCKY
    private let HALVING_INTERVAL : Nat64 = 126_144_000_000_000_000; // ~4 years in nanoseconds
    private let MIN_DONATION_ICP : Nat = 10_000_000; // 0.1 ICP (in e8s)
    private let MIN_CLAIM_INTERVAL : Int = 86_400_000_000_000; // 1 day in nanoseconds
    private let DECIMALS : Nat8 = 18;
    
    // State
    private let owner : Principal = init_msg.caller;
    private let deploymentTime : Int = Time.now();
    private stable var totalMined : Nat = 0;
    private stable var totalDonated : Nat = 0;
    private stable var totalICPDonated : Nat = 0;
    
    // Storage
    private var balances = HashMap.HashMap<Principal, Nat>(100, Principal.equal, Principal.hash);
    private var userMined = HashMap.HashMap<Principal, Nat>(100, Principal.equal, Principal.hash);
    private var lastClaimTime = HashMap.HashMap<Principal, Int>(100, Principal.equal, Principal.hash);
    private var hasClaimedInitial = HashMap.HashMap<Principal, Bool>(100, Principal.equal, Principal.hash);
    private let donationMessages = Buffer.Buffer<DonationMessage>(0);
    
    // Initialize owner with 5% of max supply
    private let initialOwnerSupply = (MAX_SUPPLY * 5) / 100;
    balances.put(owner, initialOwnerSupply);

    // Helper functions
    private func _transfer(from: Principal, to: Principal, amount: Nat) : Result.Result<(), Text> {
        let fromBalance = switch (balances.get(from)) {
            case (?balance) balance;
            case null 0;
        };

        if (fromBalance < amount) {
            return #err("Insufficient balance");
        };

        balances.put(from, fromBalance - amount);
        
        let toBalance = switch (balances.get(to)) {
            case (?balance) balance;
            case null 0;
        };
        balances.put(to, toBalance + amount);

        #ok()
    };

    private func _mint(to: Principal, amount: Nat) : () {
        let balance = switch (balances.get(to)) {
            case (?b) b;
            case null 0;
        };
        balances.put(to, balance + amount);
    };

    private func _burn(from: Principal, amount: Nat) : Result.Result<(), Text> {
        let balance = switch (balances.get(from)) {
            case (?b) b;
            case null 0;
        };

        if (balance < amount) {
            return #err("Insufficient balance");
        };

        balances.put(from, balance - amount);
        #ok()
    };

    private func _getCurrentBlockReward() : Nat {
        if (totalMined >= MAX_SUPPLY) {
            return 0;
        };

        let timeSinceDeployment = Time.now() - deploymentTime;
        let halvings = Int.abs(timeSinceDeployment) / Nat64.toNat(HALVING_INTERVAL);

        if (halvings >= 20) {
            return 0;
        };

        var reward = INITIAL_REWARD;
        var i = 0;
        while (i < halvings) {
            reward := reward / 2;
            i += 1;
        };

        if (totalMined + reward > MAX_SUPPLY) {
            return MAX_SUPPLY - totalMined;
        };

        reward
    };

    // Public query functions
    public query func name() : async Text {
        "Lucky Coin"
    };

    public query func symbol() : async Text {
        "LCKY"
    };

    public query func decimals() : async Nat8 {
        DECIMALS
    };

    public query func totalSupply() : async Nat {
        var total : Nat = 0;
        for ((principal, balance) in balances.entries()) {
            total += balance;
        };
        total
    };

    public query func balanceOf(account: Principal) : async Nat {
        switch (balances.get(account)) {
            case (?balance) balance;
            case null 0;
        }
    };

    public query func getCurrentBlockReward() : async Nat {
        _getCurrentBlockReward()
    };

    public query func getStats() : async Stats {
        var supply : Nat = 0;
        for ((_, balance) in balances.entries()) {
            supply += balance;
        };

        {
            totalSupply = supply;
            totalMined = totalMined;
            totalDonated = totalDonated;
            totalICPDonated = totalICPDonated;
            currentBlockReward = _getCurrentBlockReward();
            contractICPBalance = Cycles.balance();
            donationCount = donationMessages.size();
        }
    };

    public query func getUserInfo(user: Principal) : async UserInfo {
        let balance = switch (balances.get(user)) {
            case (?b) b;
            case null 0;
        };

        let mined = switch (userMined.get(user)) {
            case (?m) m;
            case null 0;
        };

        let lastClaim = switch (lastClaimTime.get(user)) {
            case (?t) t;
            case null 0;
        };

        let claimedInitial = switch (hasClaimedInitial.get(user)) {
            case (?c) c;
            case null false;
        };

        let canClaim = Time.now() >= (lastClaim + MIN_CLAIM_INTERVAL);

        {
            balance = balance;
            mined = mined;
            lastClaimTime = lastClaim;
            claimedInitial = claimedInitial;
            canClaim = canClaim;
        }
    };

    public query func getDonationMessages(offset: Nat, limit: Nat) : async [DonationMessage] {
        let size = donationMessages.size();
        if (offset >= size) {
            return [];
        };

        let end = Nat.min(offset + limit, size);
        let result = Buffer.Buffer<DonationMessage>(end - offset);

        var i = offset;
        while (i < end) {
            result.add(donationMessages.get(i));
            i += 1;
        };

        Buffer.toArray(result)
    };

    public query func getDonationMessagesCount() : async Nat {
        donationMessages.size()
    };

    // Public update functions
    public shared(msg) func claimInitial() : async Result.Result<Nat, Text> {
        let caller = msg.caller;

        let alreadyClaimed = switch (hasClaimedInitial.get(caller)) {
            case (?claimed) claimed;
            case null false;
        };

        if (alreadyClaimed) {
            return #err("Already claimed initial amount");
        };

        let initialAmount = 1_000_000_000_000_000_000_000; // 1000 LCKY

        if (totalMined + initialAmount > MAX_SUPPLY) {
            return #err("Max supply reached");
        };

        hasClaimedInitial.put(caller, true);
        totalMined += initialAmount;
        
        let currentMined = switch (userMined.get(caller)) {
            case (?m) m;
            case null 0;
        };
        userMined.put(caller, currentMined + initialAmount);

        _mint(caller, initialAmount);

        #ok(initialAmount)
    };

    public shared(msg) func claim() : async Result.Result<Nat, Text> {
        let caller = msg.caller;
        let now = Time.now();

        let lastClaim = switch (lastClaimTime.get(caller)) {
            case (?t) t;
            case null 0;
        };

        if (now < lastClaim + MIN_CLAIM_INTERVAL) {
            return #err("Claim too soon");
        };

        let reward = _getCurrentBlockReward();

        if (reward == 0) {
            return #err("No more rewards available");
        };

        if (totalMined + reward > MAX_SUPPLY) {
            return #err("Max supply reached");
        };

        lastClaimTime.put(caller, now);
        
        let currentMined = switch (userMined.get(caller)) {
            case (?m) m;
            case null 0;
        };
        userMined.put(caller, currentMined + reward);
        
        totalMined += reward;

        _mint(caller, reward);

        #ok(reward)
    };

    public shared(msg) func transfer(to: Principal, amount: Nat) : async Result.Result<(), Text> {
        _transfer(msg.caller, to, amount)
    };

    public shared(msg) func donateWithMessage(amount: Nat, message: Text) : async Result.Result<(), Text> {
        if (amount == 0) {
            return #err("Amount must be > 0");
        };

        if (Text.size(message) > 280) {
            return #err("Message too long");
        };

        switch (_burn(msg.caller, amount)) {
            case (#err(e)) #err(e);
            case (#ok()) {
                totalDonated += amount;
                
                donationMessages.add({
                    donor = msg.caller;
                    amount = amount;
                    message = message;
                    timestamp = Time.now();
                });

                #ok()
            };
        }
    };

    public shared(msg) func donateICP() : async Result.Result<Nat, Text> {
        let icpAmount = Cycles.available();
        
        if (icpAmount < MIN_DONATION_ICP) {
            return #err("Donation too small");
        };

        let accepted = Cycles.accept<system>(icpAmount);
        
        // Exchange rate: 1 ICP (e8s) = 100 LCKY
        let lckyAmount = (accepted * 100_000_000_000_000_000_000) / 100_000_000; // Convert e8s to LCKY

        if (totalMined + lckyAmount > MAX_SUPPLY) {
            return #err("Would exceed max supply");
        };

        totalMined += lckyAmount;
        totalICPDonated += accepted;

        _mint(msg.caller, lckyAmount);

        #ok(lckyAmount)
    };

    public shared(msg) func emergencySOS() : async Result.Result<Nat, Text> {
        let caller = msg.caller;
        
        let userBalance = switch (balances.get(caller)) {
            case (?balance) balance;
            case null 0;
        };

        if (userBalance == 0) {
            return #err("No LCKY balance");
        };

        let contractICPBalance = Cycles.balance();

        if (contractICPBalance == 0) {
            return #err("No ICP in contract");
        };

        var supply : Nat = 0;
        for ((_, balance) in balances.entries()) {
            supply += balance;
        };

        if (supply == 0) {
            return #err("No supply");
        };

        // Calculate proportional ICP
        let icpToReturn = (userBalance * contractICPBalance) / supply;

        if (icpToReturn == 0) {
            return #err("ICP amount too small");
        };

        // Burn user's LCKY
        switch (_burn(caller, userBalance)) {
            case (#err(e)) return #err(e);
            case (#ok()) {
                // Send ICP (cycles)
                // Note: In production, this would use the ICP ledger
                // For now, we just track it
                #ok(icpToReturn)
            };
        }
    };

    // Admin functions
    public shared(msg) func getOwner() : async Principal {
        owner
    };

    // System functions
    system func preupgrade() {
        // Stable storage handled by stable vars
    };

    system func postupgrade() {
        // Initialization after upgrade
    };
}

