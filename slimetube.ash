script "slimetube.ash";

cli_execute {
	/chamois
}

adventure(1, $location[The Slime Tube]);

int coat = have_effect($effect[Coated in Slime]);

adventure(coat - 3, $location[The Slime Tube]);

if (user_confirm("Go Again?") )
{
	cli_execute
	{
		slimetube.ash
	}
}
