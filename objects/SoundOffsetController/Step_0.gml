switch (test_state) {
    case E_AUDIO_SYNC_STATES.INIT:
        if (keyboard_check_pressed(vk_space)) {
            test_state = E_AUDIO_SYNC_STATES.SYNC_TEST;
        }
        break;

    case E_AUDIO_SYNC_STATES.SYNC_TEST:
        step_sound_play();
		step_input();
		break;

    case E_AUDIO_SYNC_STATES.FINISH:
        global.save_object.setting_offset_audio_performed = true;
		global.save_object.setting_offset_audio = round(beep_count_total_offset / beeps_counted);
		global.save_object.save();
        show_debug_message("Average Offset: " + string(global.save_object.setting_offset_audio));
        room_goto(roomMenu);
        break;
}