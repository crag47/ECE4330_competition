function [ ] = take_pictures( )
%system('./mvid_stream -i 1500 -2');
system('./dependencies/puma2_save_left');
system('mv mvid_save00000.ppm left.ppm');
system('./dependencies/puma2_save_right');
system('mv mvid_save00000.ppm right.ppm');

end

