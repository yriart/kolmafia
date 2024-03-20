script "slimetube.ash";

boolean chamois() {
    if (have_effect($effect[Coated in Slime]) > 0) {
        visit_url("clan_slimetube.php?action=chamois");
        refresh_status();

        if (have_effect($effect[Coated in Slime]) > 0) {
            print("Something went wrong, we're still coated in slime");
            return false;
        }
    }
    return true;
}

void main() {
    if (!chamois()) abort("Slime removal failed!");

    // When Engulfed! skip the adventure
    set_property("choiceAdventure337", "3");

    int adv_to_use = 3;
    while (my_adventures() > 0 && adv_to_use > 0) {
        adventure(1, $location[The Slime Tube]);
        if( get_property( "lastEncounter" ).contains_text( "Showdown" ) ) {
             abort( "You've reached Mother Slime!" );
        }
        if ( !( get_property( "lastEncounter" ).contains_text( "Engulfed" ) ) ) {
            adv_to_use = adv_to_use - 1;
        }    
    }    
}


// int coat = have_effect($effect[Coated in Slime]);

// adventure(coat - 3, $location[The Slime Tube]);

// if (user_confirm("Go Again?") )
//  {
// 	cli_execute
// 	{
// 		slimetube.ash
// 	}
// }
