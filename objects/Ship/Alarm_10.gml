if global.gameover = 1{global.gameover = 2; alarm[10] = 150; exit};

if global.gameover = 2{

    with Bee{instance_destroy()}

    with Butterfly{instance_destroy()}

    with Boss{instance_destroy()}; sound_stop(GBeam);

    with Transform{instance_destroy()}

    with Fighter{instance_destroy()}

    with Controller{global.gameMode = GameMode.SHOW_RESULTS; results = 1; alarm[9] = 450};

    with Stars{

    script_execute(stardelete); starspeed = 2;

    starsp = starspeed;

    script_execute(fullstarscript,starsp);

    starspeed = 0;

    }

    instance_destroy()

}




