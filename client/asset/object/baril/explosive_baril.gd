extends StaticBody

func take_damage(damage, player_origin):
	get_parent().start_explosion(player_origin)
