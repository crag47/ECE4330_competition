function [  ] = puma_defense(  )
%Defense Puts the puma robot in the defensive position

    puma_safe();
    puma_moveto_joints(-60, -200, 110, 0, 90, 70);
    puma_read();

end

