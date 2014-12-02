function gripper( command )

    % gripper opens and closes the gripper of the end effector
    % command = 'c' close, command = 'o' open

    system(strcat(strcat('echo ''', command), ''' > /usr/local/pipes/gripper'));
    
end

