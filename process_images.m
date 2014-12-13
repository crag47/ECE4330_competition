function [ l_pic, r_pic, l_n, r_n ] = process_images( l_image, r_image,intensity, areas, display, lf, rf )


    [l_pic, l_n] = improcessing(l_image,intensity/10, areas,display,lf);
    [r_pic, r_n] = improcessing(r_image,intensity/10,areas,display,rf);

    % Is object detected at this intensity
    if l_n ~= 0 && r_n ~= 0

        for n = max(l_n, r_n) : -1 : 1
            l_temp_pic = (l_pic == n); 
            r_temp_pic = (r_pic == n); 

            l_props = regionprops(l_temp_pic, 'Perimeter');
            r_props = regionprops(r_temp_pic, 'Perimeter');

            if ~isempty(l_props) && l_props.Perimeter > 500
                l_pic = l_pic - l_temp_pic * n;
                l_pic = (l_pic > 0);
                figure(5);
                imshow(l_pic);
            end

            if ~isempty(r_props) && r_props.Perimeter > 500
                r_pic = r_pic - r_temp_pic * n;
                r_pic = (r_pic > 0);
                figure(6);
                imshow(r_pic);
            end

            [l_pic, l_n] = bwlabel(l_pic, 4);
            [r_pic, r_n] = bwlabel(r_pic, 4);
        end
    end
    
    if display == 1
        figure(lf);
        subplot(3, 2, 6);
        subimage(l_pic);

        figure(rf);
        subplot(3, 2, 6);
        subimage(r_pic);
    end
    
end

