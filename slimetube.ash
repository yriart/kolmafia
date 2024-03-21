script "slimetube.ash";

boolean useChamois() {
    if (have_effect($effect[Coated in Slime]) > 0) {
        print("Attempting to use a chamois...");
        visit_url("clan_slimetube.php?action=chamois");
        refresh_status();

        if (have_effect($effect[Coated in Slime]) > 0) {
            print("Still coated in slime, there may be no chamois.");
            return false;
        }
        print("Successfully removed slime.");
    }
    return true;
}

boolean isInCombat() {
    return !(get_property("lastEncounter").contains_text("Engulfed") || get_property("lastEncounter").contains_text("Showdown"));
}

void doAdventures(int advs, int slimedLimit) {
    int totalAdvLeft = advs;

    while (totalAdvLeft > 0) {
        if (!useChamois()) abort("Slime removal failed!");

        int advLeftUntilChamois = slimedLimit;
        while (my_adventures() > 0 && advLeftUntilChamois > 0) {
            adventure(1, $location[The Slime Tube]);

            if (get_property("lastEncounter").contains_text("Showdown")) {
                abort("You have reached Mother Slime!");
            }

            if (isInCombat()) {
                advLeftUntilChamois -= 1;
                totalAdvLeft -= 1;
            }
        }
    }
}

void main(string command) {
    int totalAdvToRun = my_adventures();
    int advWhileSlimedLimit = 1;

    command = command.to_lower_case();

    if (command == "help") {
        print("SLIMETUBE.ASH INSTRUCTIONS");
        print("This script runs adventures in the slime tube for you.");
        print("It skips fighting Mother Slime and being Engulfed!");
        print("");
        print("Provide commands following the syntax: command=value");
        print("");
        print("COMMANDS:");
        print("");
        print("TOTAL: set number of adventures to run in the slimetube.");
        print("........default: all your adventures.");
        print("........ex: slimetube.ash total=50");
        print("");
        print("SLIMEDLIMIT: set number of adventures to run while you are Covered In Slime, before using a chamois.");
        print("........default: 1");
        print("........ex: slimetube.ash slimedlimit=5");
        return;
    }

    string [int] commands = command.split_string("\\s+");
    for (int i = 0; i < commands.count(); i += 1) {
        if (!(commands[i].contains_text("="))) {
            abort("Invalid command. Proper syntax is: command=value");
        }

        string [int] commandAndValue = commands[i].split_string("=");
        string comm = commandAndValue[0];
        int value = commandAndValue[1].to_int();

        if (comm == "total") totalAdvToRun = value;
        else if (comm == "slimedlimit") advWhileSlimedLimit = value;
        else abort("Invalid command. Valid commands are: total, slimedlimit");
    }

    // When Engulfed! skip the adventure
    set_property("choiceAdventure337", "3");
    // Do not fight Mother Slime
    set_property("choiceAdventure326", "0");

    print("Beginning Slime Tube run for " + totalAdvToRun + " using a chamois every " + advWhileSlimedLimit + " adventures.");
    doAdventures(totalAdvToRun, advWhileSlimedLimit);

    print("Finished Slime Tube run.");
    if (!useChamois()) abort("Slime removal failed!");
}
