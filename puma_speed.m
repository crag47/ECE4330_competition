function puma_speed( command )

    % gripper opens and closes the gripper of the end effector
    % command = 'c' close, command = 'o' open

    system(['Puma_SPEED', ' ', int2str(command)]);
    
end

