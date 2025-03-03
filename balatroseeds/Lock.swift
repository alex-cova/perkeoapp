//
//  Lock.swift
//  balatroseeds
//
//  Created by Alex on 03/01/25.
//
class Lock {
    
    private var lock: [Int] = Array(repeating: 0, count: 13)
    
    func unlock(_ item: Item) {
        lock[item.y] = lock[item.y] & ~(1 << item.ordinal)
    }
    
    func lock(_ item: Item) {
        lock[item.y] = lock[item.y] | (1 << item.ordinal)
    }
    
    func isLocked(_ item: Item) -> Bool {
        return (lock[item.y] & (1 << item.ordinal)) != 0
    }
    
    func initUnlocks(_ ante: Int, _ freshProfile: Bool) {
        if ante <= 1 || ante > 6 { return }
        
        if ante == 2 {
            unlock(Boss.The_Mouth)
            unlock(Boss.The_Fish)
            unlock(Boss.The_Wall)
            unlock(Boss.The_House)
            unlock(Boss.The_Mark)
            unlock(Boss.The_Wheel)
            unlock(Boss.The_Arm)
            unlock(Boss.The_Water)
            unlock(Boss.The_Needle)
            unlock(Boss.The_Flint)
            
            unlock(Tag.Standard_Tag)
            unlock(Tag.Meteor_Tag)
            unlock(Tag.Buffoon_Tag)
            unlock(Tag.Handy_Tag)
            unlock(Tag.Garbage_Tag)
            unlock(Tag.Ethereal_Tag)
            unlock(Tag.Top_up_Tag)
            unlock(Tag.Orbital_Tag)
            
            if !freshProfile { unlock(Tag.Negative_Tag) }
        }
        if ante == 3 {
            unlock(Boss.The_Tooth)
            unlock(Boss.The_Eye)
        }
        if ante == 4 { unlock(Boss.The_Plant) }
        if ante == 5 { unlock(Boss.The_Serpent) }
        if ante == 6 { unlock(Boss.The_Ox) }
    }
    
    func initLocks(_ ante: Int, _ freshProfile: Bool, _ freshRun: Bool) {
        if (ante < 2) {
            lock(Boss.The_Mouth);
            lock(Boss.The_Fish);
            lock(Boss.The_Wall);
            lock(Boss.The_House);
            lock(Boss.The_Mark);
            lock(Boss.The_Wheel);
            lock(Boss.The_Arm);
            lock(Boss.The_Water);
            lock(Boss.The_Needle);
            lock(Boss.The_Flint);
            lock(Tag.Negative_Tag);
            lock(Tag.Standard_Tag);
            lock(Tag.Meteor_Tag);
            lock(Tag.Buffoon_Tag);
            lock(Tag.Handy_Tag);
            lock(Tag.Garbage_Tag);
            lock(Tag.Ethereal_Tag);
            lock(Tag.Top_up_Tag);
            lock(Tag.Orbital_Tag);
        }
        
        if ante < 3 {
            lock(Boss.The_Tooth)
            lock(Boss.The_Eye)
        }
        
        if ante < 4 { lock(Boss.The_Plant) }
        if ante < 5 { lock(Boss.The_Serpent) }
        if ante < 6 { lock(Boss.The_Ox) }
        
        if freshProfile {
            lock(CommonJoker.Golden_Ticket)
            lock(CommonJoker.Hanging_Chad)
            lock(CommonJoker.Shoot_the_Moo)
            lock(CommonJoker.Swashbuckler)
            
            lock(RareJoker.Blueprint)
            lock(RareJoker.Brainstorm)
            lock(RareJoker.Drivers_License)
            lock(RareJoker.Hit_the_Road)
            lock(RareJoker.Invisible_Joker)
            lock(RareJoker.The_Duo)
            lock(RareJoker.The_Family)
            lock(RareJoker.The_Order)
            lock(RareJoker.The_Tribe)
            lock(RareJoker.The_Trio)
            lock(RareJoker.Wee_Joker)
            
            lock(Tag.Foil_Tag)
            lock(Tag.Holographic_Tag)
            lock(Tag.Polychrome_Tag)
            lock(Tag.Rare_Tag)
            
            lock(UnCommonJoker.Acrobat)
            lock(UnCommonJoker.Arrowhead)
            lock(UnCommonJoker.Bloodstone)
            lock(UnCommonJoker.Certificate)
            lock(UnCommonJoker.Glass_Joker)
            lock(UnCommonJoker.Mr_Bones)
            lock(UnCommonJoker.Onyx_Agate)
            lock(UnCommonJoker.Rough_Gem)
            lock(UnCommonJoker.Showman)
            lock(UnCommonJoker.Smeared_Joker)
            lock(UnCommonJoker.Sock_and_Buskin)
            lock(UnCommonJoker.Throwback)
            lock(UnCommonJoker.Troubadour)
            lock(UnCommonJoker100.Astronomer)
            lock(UnCommonJoker100.Bootstraps)
            lock(UnCommonJoker100.Burnt_Joker)
            lock(UnCommonJoker100.Cartomancer)
            lock(UnCommonJoker100.Flower_Pot)
            lock(UnCommonJoker100.Matador)
            lock(UnCommonJoker100.Merry_Andy)
            lock(UnCommonJoker100.Satellite)
            lock(UnCommonJoker100.Seeing_Double)
            lock(UnCommonJoker100.Stuntman)
            lock(UnCommonJoker100.The_Idol)
            lock(UnCommonJoker101C.Oops_All_6s)
            
            lock(Voucher.Antimatter)
            lock(Voucher.Glow_Up)
            lock(Voucher.Illusion)
            lock(Voucher.Liquidation)
            lock(Voucher.Money_Tree)
            lock(Voucher.Nacho_Tong)
            lock(Voucher.Observatory)
            lock(Voucher.Omen_Globe)
            lock(Voucher.Overstock_Plus)
            lock(Voucher.Palett)
            lock(Voucher.Petroglyph)
            lock(Voucher.Planet_Tycoon)
            lock(Voucher.Recyclomancy)
            lock(Voucher.Reroll_Glut)
            lock(Voucher.Retcon)
            lock(Voucher.Tarot_Tycoon)
            
            lock(Tag.Negative_Tag)
        }
        
        if freshRun {
            lock(Planet.Planet_X)
            lock(Planet.Ceres)
            lock(Planet.Eri)
            // RareJoker.Five_of_a_Kind;
            // Voucher.Flush_House;
            // Voucher.Flush_Five;
            lock(UnCommonJoker.Stone_Joker)
            lock(UnCommonJoker.Steel_Joker)
            lock(UnCommonJoker.Glass_Joker)
            lock(UnCommonJoker100.Lucky_Cat)
            
            lock(CommonJoker.Golden_Ticket)
            lock(CommonJoker.Cavendish)
            
            lock(Voucher.Overstock_Plus)
            lock(Voucher.Liquidation)
            lock(Voucher.Glow_Up)
            lock(Voucher.Reroll_Glut)
            lock(Voucher.Omen_Globe)
            lock(Voucher.Observatory)
            lock(Voucher.Nacho_Tong)
            lock(Voucher.Recyclomancy)
            lock(Voucher.Tarot_Tycoon)
            lock(Voucher.Planet_Tycoon)
            lock(Voucher.Money_Tree)
            lock(Voucher.Antimatter)
            lock(Voucher.Illusion)
            lock(Voucher.Petroglyph)
            lock(Voucher.Retcon)
            lock(Voucher.Palett)
        }
    }
    
    func firstLock() {
        lock(Voucher.Overstock_Plus)
        lock(Voucher.Liquidation)
        lock(Voucher.Glow_Up)
        lock(Voucher.Reroll_Glut)
        lock(Voucher.Omen_Globe)
        lock(Voucher.Observatory)
        lock(Voucher.Nacho_Tong)
        lock(Voucher.Recyclomancy)
        lock(Voucher.Tarot_Tycoon)
        lock(Voucher.Planet_Tycoon)
        lock(Voucher.Money_Tree)
        lock(Voucher.Antimatter)
        lock(Voucher.Illusion)
        lock(Voucher.Petroglyph)
        lock(Voucher.Retcon)
        lock(Voucher.Palett)
    }
    
}

