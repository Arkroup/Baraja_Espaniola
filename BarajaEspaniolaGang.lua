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
	pos = { x = 2, y = 0 },
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
			'You can play {C:attention}flush{} with {C:attention}2{} cards.',
			'If doing so, add {X:mult}Mult{} equal to',
			'{X:mult}20{} + sum of ranks of',
			'numbered cards in scoring hand.'
		}
    },
    atlas = 'BarajaEspaniolaJokers',
    pos = { x = 0, y = 0 },
    rarity = 1,
    blueprint_compat = false,
    cost = 6,
	config = { extra = { mult = 20, hand_type = 'Flush'} },
	loc_vars = function(self, info_queue, card)
		return { vars = { card:get_id(), localize(card.ability.extra.hand_type, 'poker_hands') } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and next(context.poker_hands[card.ability.extra.hand_type]) and #context.scoring_hand == 2 and context.other_card:is_numbered() then
			if context.other_card:get_id() == 14 then
				return{
					mult_mod = 1,
					message = localize { type = 'variable', key = 'a_mult', vars = { 1 } },
					card = context.other_card
				}
			else
				return {
					mult_mod = context.other_card:get_id(),
					message = localize { type = 'variable', key = 'a_mult', vars = { context.other_card:get_id() } },
					card = context.other_card
				}
			end
		end
		if context.joker_main and next(context.poker_hands[card.ability.extra.hand_type]) and #context.scoring_hand == 2 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'envido2',
	loc_txt = {
		name = 'Envido Envido',
		text = {
			'You can play {C:attention}flush{} with {C:attention}2{} cards.',
			'If doing so, {X:mult}X#1#{} Mult.',
			'Increase by 0.1 per {C:attention}flush{} played.'
		}
	},
	config = { extra = { Xmult = 1, Xmult_gain = 0.1 } },
	rarity = 2,
	atlas = 'BarajaEspaniolaJokers',
	pos = { x = 3, y = 0 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_gain } }
	end,
	calculate = function(self, card, context)	
		if context.joker_main and next(context.poker_hands['Flush']) and #context.scoring_hand == 2 then
			return {
				x_mult = card.ability.extra.Xmult,
			}
		end
		if context.before and next(context.poker_hands['Flush']) and not context.blueprint then
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.MULT,
				card = card
			}
		end
	end
}

SMODS.Joker({
	key = "setenta",
	atlas = "BarajaEspaniolaJokers",
	loc_txt = {
		name = 'Setenta',
		text = {
			'Retrigger every {C:attention}7{} once for each',
			'previously scored {C:attention}7{} this hand.'
		}
	},
	pos = { x = 1, y = 0 },
	rarity = 2,
	cost = 6,
	config = { extra = { repetitions = -1, repetitions_gain = 1 } },
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.repetitions, card.ability.extra.repetitions_gain}}
	end,
	calculate = function(self, card, context)
		if context.before then
            card.ability.extra.repetitions = -1
        end
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
			if context.other_card.base.id == 7 then
				card.ability.extra.repetitions = card.ability.extra.repetitions + card.ability.extra.repetitions_gain
				return {
					message = 'Again!',
					repetitions = card.ability.extra.repetitions,
					card = context.other_card
				}
			end
		end
    end
})

SMODS.Joker {
	key = 'vale4',
	loc_txt = {
		name = 'Vale 4',
		text = {
			"If played hand is {C:attention}high card{},",
			"and card is an {C:attention}Ace{},",
			"{C:attention}7{}, {C:attention}3{} or {C:attention}2{}, {X:mult}X#1#{} Mult."
		}
	},
	rarity = 3,
	atlas = 'BarajaEspaniolaJokers',
	pos = { x = 4, y = 0 },
	cost = 4,
	config = { extra = { Xmult = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.scoring_name == 'High Card' then
                if context.scoring_hand[1]:get_id() == 14 or context.scoring_hand[1]:get_id() == 7 or context.scoring_hand[1]:get_id() == 3 or context.scoring_hand[1]:get_id() == 2 then
                    return {
                        x_mult = card.ability.extra.Xmult
                    }
                end
            end
        end
    end
}

SMODS.Joker {
	key = 'faltaEnvido',
	loc_txt = {
		name = 'Falta Envido',
		text = {
			"You can play {C:attention}flush{} with {C:attention}2{} cards.",
			"If doing so, {X:mult}X#1#{} Mult,",
			"increase by 0.15 per {C:attention}flush{} played this game."
		}
	},
	rarity = 3,
	atlas = 'BarajaEspaniolaJokers',
	pos = { x = 5, y = 0 },
	cost = 4,
	config = { extra = { Xmult = 1, Xmult_gain = 0.15 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult, card.ability.extra.Xmult_gain } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		if G.GAME and G.GAME.hand_usage then
			card.ability.extra.Xmult = 1 + G.GAME.hands["Flush"].played * card.ability.extra.Xmult_gain
		else
			card.ability.extra.Xmult = 1
		end
    end,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands['Flush']) then 
			card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
			return {
				message = 'Upgraded!',
				colour = G.C.MULT,
				card = card
			}
		end
		if context.joker_main and next(context.poker_hands['Flush']) and #context.scoring_hand == 2 then
			return {
				x_mult = card.ability.extra.Xmult,
			}
		end
	end
}

SMODS.Joker{
	key = "oros",
	atlas = "BarajaEspaniolaJokers",
	loc_txt = {
		name = 'Oros',
		text = {
			"{X:mult}X#1#{} Mult. Increases by X0.1",
			"per {C:diamonds}diamond{} card in full deck."
		}
	},
	rarity = 1,
	blueprint_compat = true,
	pos = {x = 6, y = 0},
	cost = 5,
	config = {extra = {Xmult = 1, Xmult_gain = 0.1}},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.Xmult, card.ability.extra.Xmult_gain}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			card.ability.extra.Xmult = 1
       		for i,v in pairs(G.playing_cards) do
     	       if v:is_suit("Diamonds") then
      	        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
     	       end
      	  	end
			return {
				x_mult = card.ability.extra.Xmult,
			}
		end
	end,
}

SMODS.Joker({
	key = "retruco",
	atlas = "BarajaEspaniolaJokers",
	loc_txt = {
		name = 'Retruco',
		text = {
			"When playing high card,",
			"retrigger scoring card for",
			"every {C:attention}ace{} and {C:attention}7{} held in hand."
		}
	},
	pos = {x = 7, y = 0},
	rarity = 2,
	cost = 6,
	config = {extra = { repetitions = 0 }},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.repetitions}}
	end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
			card.ability.extra.repetitions = 0
            if context.scoring_name == 'High Card' then
				for i,v in pairs(G.hand.cards) do
					if v:get_id() == 14 or v:get_id() == 7 then
						if v.ability.effect ~= 'Stone Card' then
                			card.ability.extra.repetitions = card.ability.extra.repetitions + 1
						end
					end
				end
				return {
					message = localize('k_again_ex'),
					repetitions = card.ability.extra.repetitions,
					card = card
				}
            end
        end
    end
})

SMODS.Joker({
	key = "cartas",
	atlas = "BarajaEspaniolaJokers",
	loc_txt = {
		name = 'Cartas',
		text = {
			"{C:chips}+#1#{} Chips for each",
			"card above {C:attention}#3#{}",
			"in your full deck",
			"{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
		}
	},
	pos = {x = 8, y = 0},
	rarity = 1,
	cost = 4,
	config = {extra = { chips_per_card = 20 }},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips_per_card, math.max(0,card.ability.extra.chips_per_card*(G.playing_cards and (#G.playing_cards - G.GAME.starting_deck_size) or 0)), G.GAME.starting_deck_size}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and (#G.playing_cards - G.GAME.starting_deck_size) > 0 then
            return {
                chips = card.ability.extra.chips_per_card*(#G.playing_cards - G.GAME.starting_deck_size),
            }
        end
    end
})