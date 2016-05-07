function plotFeat(FeatStat)

        FeatIndex=FeatStat(:,1);   
        FeatScore=FeatStat(:,2);      
        
        % Get the list of missing indexes
        % FeatIndex		list of variables selected
        % notSel        list of indexes not present
        % nv            total number of variables
        nv=15500;
        notSel=[];
        for cnti=1:nv,
            selected=0;
            for cntj=1:length(FeatIndex)
              if FeatIndex(cntj)==cnti
                selected=1;
                break;
              end
            end
            if ~(selected)
              notSel=[notSel, cnti];
            end
        end
       
        % Append the missing indexes to the Feat index
        FeatStat=[FeatIndex' notSel; FeatScore' zeros(size(notSel))]';
        FeatStat=sortrows(FeatStat,1);
        FeatScore=FeatStat(:,2)'; 
        FeatStat=[];
%        Face=dlmread('data\Face.txt');
        Face=dlmread('data/Face.txt'); %on MAC
        % reshape data to display
        size(FeatScore);
        FeatListOD=FeatScore(1:7750);
        FeatListOD=reshape(FeatListOD,[125 62]);
        FeatListOD=[FeatListOD fliplr(FeatListOD)];
        mnOD=min(FeatListOD(:));
        mxOD=max(FeatListOD(:));        
        FeatListOD(FeatListOD<=0)=0;
        FeatListOD(1)=mnOD; FeatListOD(2)=mxOD;
                    
        FeatListHD=FeatScore(7751:end);
        FeatListHD=reshape(FeatListHD,[125 62]);
        FeatListHD=[FeatListHD fliplr(FeatListHD)];
        mnHD=min(FeatListHD(:));
        mxHD=max(FeatListHD(:));        
        FeatListHD(FeatListHD<=0)=0;
        FeatListHD(1)=mnHD; FeatListHD(2)=mxHD;
        FeatScore=[];


        figure;
        subplot(121);
            imMask=imread('data/mask.jpg');
%             imshow(imMask)
            
%             set(gca,'YDir','reverse')
            view(0,90);
            axis tight;
            freezeColors;
            hold on;
%             colorbar vert
            colormap jet;
            [xx,yy] = meshgrid(1:124,1:125);
            x = xx((FeatListOD)~=0);
            y = yy((FeatListOD)~=0);
            z = Face((FeatListOD)~=0);
            v = FeatListOD((FeatListOD)~=0);
%             colormap gray
                
            hold on;
            plot3c(x(:),y(:),z(:),v(:),'.');
%             set(gca, 'CLim', [min(FeatListOD((FeatListOD)~=0)),max(FeatListOD((FeatListOD)~=0))])
            view(0,90)
            freezeColors;
%             freezeColors(colorbar);
%             hold on;
            
            colormap gray
            surface(xx,yy,(Face),flipud(imMask),'FaceColor','texturemap',...
                    'EdgeColor','none');
%           
            freezeColors;
            
            
%             imshow(imMask)
%             set(gca,'YDir','reverse')
            view(0,90);
            axis off;
            hold off;
            title('OD features');
        subplot(122);
            imMask=imread('data/mask.jpg');
%             imshow(imMask)
            
%             set(gca,'YDir','reverse')
            view(0,90);
            axis tight;
            hold on;
%             colorbar vert
            colormap jet;
            [xx,yy] = meshgrid(1:124,1:125);
            x = xx((FeatListHD)~=0);
            y = yy((FeatListHD)~=0);
            z = Face((FeatListHD)~=0);
            v = FeatListHD((FeatListHD)~=0);
            
            plot3c(x(:),y(:),z(:),v(:),'.');
            view(0,90)
            freezeColors;
            hold on;
            colormap gray
            surface((Face),flipud(imMask),'FaceColor','texturemap',...
                    'EdgeColor','none');
            set(gca, 'CLim', [0,255])
            
%             imshow(imMask)
%             set(gca,'YDir','reverse')
            view(0,90);
            axis off;
            hold off;
%             surf(flipud(Face+FeatListHD),flipud(FeatListHD),'facecolor','interp','edgecolor','interp','edgecolor','none')
%             colorbar vert
%             colormap jet;
%             view(0,90)
%             freezeColors;
%             freezeColors(colorbar);
%             hold on;
%             
%             surface(flipud(Face),(imMask),'FaceColor','texturemap',...
%                     'EdgeColor','none',...
%                     'CDataMapping','direct');
%             colormap gray
%             view(0,90);
%             axis tight;
% %             imshow(imMask)
%             set(gca,'YDir','reverse')
%             view(0,90);
%             hold off;
            title('HD features');
            xlabel('You can also rotate these figures in 3D');
units=get(gcf,'units');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gcf,'units',units);







