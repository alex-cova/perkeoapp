//
//  RunScorer.swift
//  balatroseeds
//
//  Created by Alex on 31/07/25.
//

extension Run {
    
    var score : Int {
        let run = self
        var score: Float = 0.0

        for ante in run.antes {
            score += calculateScore(ante)
        }

        if run.hasLegendary(LegendaryJoker.Perkeo) {
            if run.hasVoucher(.Observatory) {
                score += 25.0
            }

            if run.hasJoker(RareJoker.Blueprint, 10) {
                score += 25.0
            }

            if run.hasJoker(RareJoker.Brainstorm, 10) {
                score += 25.0
            }

            if run.hasJoker(RareJoker.Baron, 10) && run.hasJoker(UnCommonJoker.Mime, 10) {
                score += 15.0
            }
        }

        if run.hasLegendary(.Triboulet) {
            if run.hasJoker(RareJoker.Blueprint, 10) {
                score += 25.0
            }

            if run.hasJoker(RareJoker.Brainstorm, 10) {
                score += 25.0
            }

            if run.hasJoker(UnCommonJoker.Sock_and_Buskin, 10) {
                score += 25.0
            }
        }

        if run.hasLegendary(LegendaryJoker.Canio) {
            if run.hasJoker(UnCommonJoker.Pareidolia, 10) {
                score += 25.0
            }
        }

        return Int(score)
    }

    private func calculateScore(_ ante: Ante) -> Float {
        var score: Float = 0.0

        for value in ante.legendaries ?? [] {
            score = (50 * Float(value.type.rarity)) * value.edition.multiplier
        }

        for (i, item) in ante.shopQueue.enumerated() {
            if let joker = item.item as? Joker {
                let pre = Float(joker.type.rarity) * Float(item.edition?.multiplier ?? 0.0)
                score += ((50 - Float(i)) * pre)
            }

            if i > 30 {
                continue
            }

            if item.item is Spectral {
                if item.equals(Spectral.Cryptid) {
                    score += 2.0
                }
                if item.equals(Spectral.Deja_Vu) {
                    score += 4.0
                }
            }

            if item.item is Tarot {
                if item.equals(Tarot.Temperance) {
                    score += 2.0
                }
                if item.equals(Tarot.The_Hermit) {
                    score += 1.5
                }
                if item.equals(Tarot.The_Fool) {
                    score += 1.0
                }
            }
        }

        for pack in ante.packs {
            if pack.kind == .Standard { continue }
            score += Float(pack.choices)

            if pack.kind == .Spectral {
                if pack.containsOption(Spectral.Cryptid.rawValue) {
                    score += 2.0
                }
                if pack.containsOption(Spectral.Deja_Vu.rawValue) {
                    score += 4.0
                }
            }

            if pack.kind == .Arcana {
                if pack.containsOption(Tarot.Temperance.rawValue) {
                    score += 2.0
                }
                if pack.containsOption(Tarot.The_Hermit.rawValue) {
                    score += 1.5
                }
                if pack.containsOption(Tarot.The_Fool.rawValue) {
                    score += 1.0
                }
            }

            if pack.kind == .Buffoon {
                for option in pack.options {
                    if let joker = option.item as? Joker {
                        score += (50 * Float(joker.type.rarity)) * option.edition.multiplier
                    }
                    
                }
            }
        }

        let tags = ante.tags
        let boss = ante.boss
        let voucher = ante.voucher

        for tag in tags {
            switch tag {
            case .Negative_Tag:
                score += 5.0
            case .Charm_Tag:
                score += 0.5
            default:
                break
            }
        }

        if boss == .The_Arm {
            score -= 0.5
        }

        if ante.hasInPack(Specials.BLACKHOLE) {
            score += 5.0
        }

        switch voucher {
        case .Blank:
            score += 1.0
        case .Clearance_Sale:
            score += 0.5
        case .Overstock:
            score += 0.2
        case .Liquidation:
            score += 0.5
        case .Hieroglyph:
            score += 0.5
        case .Paint_Brush:
            score += 0.5
        case .Recyclomancy:
            score += 0.5
        case .Grabber:
            score += 0.5
        case .Wasteful:
            score += 0.2
        default:
            break
        }

        score += Float(max(0, 8 - ante.ante)) * 10

        return score
    }
}
