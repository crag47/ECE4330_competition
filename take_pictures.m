function [ ] = take_pictures( puma_number)
%system('./mvid_stream -i 1500 -2');
system(strcat(strcat('./dependencies/puma', puma_number), '_save_left'));
system('mv mvid_save00000.ppm left.ppm');
system(strcat(strcat('./dependencies/puma', puma_number), '_save_right'));
system('mv mvid_save00000.ppm right.ppm');

end

