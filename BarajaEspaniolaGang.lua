SMODS.Atlas {
    key = "modicon",
    path = "mod_icon.png",
    px = 34,
    py = 34,
}

SMODS.Atlas {
    key = "BarajaEspaniolaJokers",
    path = "BarajaEspaniolaJokers.png",
    px = 71,
    py = 95,
}

SMODS.Joker {
	key = 'sietedeoros',
	loc_txt = {
		name = '7 de oros',
		text = {
			"Each played {C:attention}7{} of {C:diamonds}Diamonds{}",
			"gives {X:mult,C:white} X#1# {} Mult"
		}
	},
	config = { extra = { Xmult = 2} },
	rarity = 1,
	atlas = 'BarajaEspaniolaJokers',
	pos = { x = 1, y = 1 },
	cost = 4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit('Diamonds') and context.other_card.base.value == '7' then
				return {
					x_mult = card.ability.extra.Xmult,
					card = context.other_card
				}
			end
		end
	end,
	blueprint_compat = true
}

SMODS.Joker {
    key = 'envido',
    loc_txt = {
        name = 'Envido',
        text = {
			'You can play {C:attention}flush{} with {C:attention}2{} cards. ',
			'If doing so, add {X:mult}Mult{} equal to',
			'{X:mult}20{} + sum of ranks',
			'of numbered cards in scoring hand.'
		}
    },
    atlas = 'BarajaEspaniolaJokers',
    pos = {
        x = 0,
        y = 0
    },
    rarity = 1,
    blueprint_compat = false,
    cost = 6,
	config = { extra = { mult = 20, hand_type = 'Flush'} },
	loc_vars = function(self, info_queue, card)
		return { vars = { card:get_id(), localize(card.ability.extra.hand_type, 'poker_hands') } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and next(context.poker_hands[card.ability.extra.hand_type]) and #context.scoring_hand == 2 and context.other_card:is_numbered() then
			return {
				mult_mod = context.other_card:get_id(),
				message = localize { type = 'variable', key = 'a_mult', vars = { context.other_card:get_id() } },
				card = context.other_card
			}
		end
		if context.joker_main and next(context.poker_hands[card.ability.extra.hand_type]) and #context.scoring_hand == 2 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end,
}