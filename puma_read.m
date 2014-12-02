function [ XYZOAT] = puma_read( )
	XYZOAT = zeros(1,6);
    system('Puma_READ r > XYZOATdata.txt');
	f = fopen('XYZOATdata.txt', 'r');
    
	while 1
		l = fgets(f);
		
		% break if EOF
        if l == -1
            fclose(f);
            break;
        end
		
		XYZOAT = str2num(l);
		
        if isempty(XYZOAT)
            XYZOAT = zeros(1, 6);
        end
        
		% break if str2num succeeded
		if XYZOAT ~= [0, 0, 0, 0, 0, 0]
			fclose(f);
			break;
		end
	end

end

