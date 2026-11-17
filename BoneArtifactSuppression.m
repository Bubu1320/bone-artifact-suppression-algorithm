close all;
clear;
clc; 

folderpath = uigetdir();

f_end = 50; %平均次数
w = 0.1;


files=dir(fullfile(folderpath,'*.dat*'));
numfiles=min(f_end,length(files));
selectedfiles=files(1:numfiles);

for i=1:numfiles
    filepath=fullfile(folderpath,selectedfiles(i).name);
    
    datae_128(i,:,:)= trans_data_128(filepath);
    fclose('all');
end



[num,n0,m0] = size(datae_128);                      
datae=zeros(n0,m0);
for n = 1:num
    for i = 1:n0
        for j = 1:m0
            datae(i,j) = datae(i,j)+datae_128(n,i,j) ;
        end
    end
end
datae=datae/f_end;


for channel = 1:size(datae, 2)
    smoothedData = smoothdata(datae(:, channel), 'movmean',5); % Number of averaging frames
    datae(:, channel) = smoothedData; % Smooth data with moving average; other smoothing methods are optional
end




nd=128;                         % total number of detectors
delay=0;                        % number of points delayed when you record the
xc=0; yc=0;  %   -x_left_move  -y_up_move
x1=xc-30; x2=xc+30;         % image area in X direction
y1=yc-30; y2=yc+30;         % image area in Y direction
xd=0.2;  yd=0.2;            % image resolution selection. When searching 0.05
                            % reconstruction radius, suggested value is 0.2. After
                            % getting the reconstruction radius, 0.02
                            % recommended
R0=69; R0d=1; ntry=1;     
 

v0=1.40; v0d=0.01; vtry=1;     % ultrasound velocity

ntime=0.025;                     % ntime=1/f; f is sampling rate (in MHz)


nx=floor((x2-x1)/xd)+1;
ny=floor((y2-y1)/yd)+1;
xlabel=x1:xd:x2;
ylabel=y1:yd:y2;

p = zeros(1,1000);
smu = 0;
 for t = n0/2 : n0/2 + 1000
     p(t)= t + 200;
     smu = smu + datae(p(t),1);
     avr = smu/1000;

 end



for vtryy = 1:vtry
    for ntryy=1:ntry
        pics=zeros(ny,nx);
        R=R0+R0d*(ntryy-1);
        V=v0+v0d*(vtryy-1);
        j=1:128;
        detx(j)=R*cos((j-1)*1.4*pi/180);
        dety(j)=R*sin((j-1)*1.4*pi/180);
   
    
            for xx=1:nx
                x=x1+(xx-1)*xd;
                for yy=1:ny
                    y=y1+(yy-1)*yd;
                    for i=1:nd
                        dis2=(x-detx(i))^2+(y-dety(i))^2;
                        dis=floor(sqrt(dis2)/V/ntime)+1;
                        q(dis,i)=datae(dis,i)-avr;        
                        pics(yy,xx)=pics(yy,xx)+q(dis-delay,i);
                    end
                end
            end
            
    figure;
    pics=flipud(pics);
    pics=fliplr(pics);
    imagesc(xlabel,ylabel,pics);
    colorbar;
    colormap(gray);
        title(sprintf('%.3f mm, %.3f mm/us',R,V));
    end
end

x_limit = xlim ;                                 
y_limit = ylim ;
[y_num,x_num] = size(pics);




figure
imagesc(xlabel,ylabel,pics);
colorbar;
colormap(gray);
title(sprintf('Bone ROI selection'));

disp("Please select the bone region!") ;
ROI_bone = drawpolygon('color','r') ;         %Manually select the target tissue region and save boundary coordinates
ROI_coordinate_bone = ROI_bone.Position ;          
disp("ROI finish!"); 

pics_ROI_bone = zeros(y_num,x_num); 

for y_p = 1 : y_num                          %Generate binary mask for selected ROI: 1 inside ROI, 0 outside
    for x_p = 1 : x_num
        x_coordinate = x_p * xd + x_limit(1);
        y_coordinate = y_p * yd + y_limit(1);
        point_in=inpolygon(x_coordinate,y_coordinate,ROI_coordinate_bone(:,1),ROI_coordinate_bone(:,2));
        if(point_in == 1) 
           pics_ROI_bone(y_p,x_p) = 1;
        end
    end
end


figure
imagesc(xlabel,ylabel,pics_ROI_bone);
colorbar;
colormap(gray);
title(sprintf('Bone ROI mask'));

pics_ROI_bone=flipud(pics_ROI_bone);
pics_ROI_bone=fliplr(pics_ROI_bone);
ROI_coordinate_bone=-1*ROI_coordinate_bone;



for vtryy = 1:vtry
    for ntryy=1:ntry
        pics_new=zeros(ny,nx);
        R=R0+R0d*(ntryy-1);
        V=v0+v0d*(vtryy-1);
        j=1:128;
        detx(j)=R*cos((j-1)*1.4*pi/180);
        dety(j)=R*sin((j-1)*1.4*pi/180);
            for xx=1:nx
                x=x1+(xx-1)*xd;
                for yy=1:ny
                    y=y1+(yy-1)*yd;
                    for i=1:nd
                        point_in_roi=inpolygon(x,y,ROI_coordinate_bone(:,1),ROI_coordinate_bone(:,2));
                        coef=polyfit([x,detx(i)],[y,dety(i)],1);
                        num_point=floor(abs(x-detx(i))/xd);               
                        x_point=linspace(x, detx(i), num_point + 1); 
                        y_point=coef(1)*x_point+coef(2);
                        pics_w = 0;
                        for num_p=0:num_point
                            pics_x = floor((x_point(num_p+1) - x1) / xd + 1);
                            pics_y = floor((y_point(num_p+1) - y1) / yd + 1);
                            
                            if((pics_x > 0) && (pics_y > 0) && (pics_y <= ny) && (pics_x <= nx))
                                 if(pics_ROI_bone(pics_y,pics_x)==1)
                                    pics_w = pics_w + 1;
                                 else    
                                    pics_w = pics_w;
                                 end        
                            end
                        end
                        
                        dis2=(x-detx(i))^2+(y-dety(i))^2;
                        dis=floor(sqrt(dis2)/V/ntime)+1;
                        q=datae(dis,i)-avr; 
                        if(pics_w == 0)
                        pics_new(yy,xx)=pics_new(yy,xx)+q;
                        elseif(point_in_roi==1)
                        pics_new(yy,xx)=pics_new(yy,xx)+q;
                        else
                        pics_new(yy,xx)=pics_new(yy,xx)+w*q;
                        end
                    end

                end
            end
            
    h = fspecial('average', [5 5]); % 5×5 averaging filter kernel
    pics_ok = imfilter(pics_new, h, 'replicate');
            
    figure;
    pics_ok=flipud(pics_ok);
    pics_ok=fliplr(pics_ok);
    imagesc(xlabel,ylabel,pics_ok);
    colorbar;
    colormap(gray);
    title(sprintf('Bone artifact suppressed reconstruction'));
    end
end