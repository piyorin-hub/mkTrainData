function Horof43
%ウィンドウのサイズ読み込み
r=groot;
SW=r.ScreenSize(3);
SH=r.ScreenSize(4);
BSize=SW/24;
Fsize=SW/64;

%ウィンドウ表示
fig=uifigure('Name','Horof ver4.2','Position',[0,0,SW,SH]);

%パネル
imageXarea=uiimage('parent',fig,'Position',[0 SH*0.3,SW/3 SH*0.6]);
imageYarea=uiimage('parent',fig,'Position',[SW/3 SH*0.3,SW/3 SH*0.6]);
imageZarea=uiimage('parent',fig,'Position',[SW*2/3 SH*0.3,SW/3 SH*0.6]);

%ベクトル、座標、倍率初期値
CurrentX=[1 0 0]; %Xベクトル
CurrentY=[0 1 0]; %Yベクトル
CurrentZ=[0 0 1]; %Zベクトル
CurrentO=[0 0 0]; %ベクトル原点座標

%変数初期値
V=0; %ボリューム
file=0;
VR=0; %ボリュームのR成分
VG=0; %ボリュームのG成分
VB=0; %ボリュームのB成分
Label=0; %air=0,tissue=1,trmd=2のラベル

%文字
uilabel(fig,'Position',[SW/6-25,SH*0.2,100,100],...
    'Text',"⇄",'Fontsize',Fsize);
uilabel(fig,'Position',[SW/6-25,SH*0.1,100,100],...
    'Text',"⟳",'Fontsize',Fsize);
uilabel(fig,'Position',[SW/2-25,SH*0.2,100,100],...
    'Text',"⇄",'Fontsize',Fsize);
uilabel(fig,'Position',[SW/2-25,SH*0.1,100,100],...
    'Text',"⟳",'Fontsize',Fsize);
uilabel(fig,'Position',[SW/1.2-25,SH*0.2,100,100],...
    'Text',"⇄",'Fontsize',Fsize);
uilabel(fig,'Position',[SW/1.2-25,SH*0.1,100,100],...
    'Text',"⟳",'Fontsize',Fsize);
filename=uilabel(fig,'Position',[BSize*7,SH*0.98-BSize,SW/2,BSize],...
    'Text',".matファイルを選択",'Fontsize',Fsize);

%ボタン

uibutton(fig,'Text','ボリュームデータ選択','Fontsize',Fsize,'Position',[0,SH*0.98-BSize,BSize*6,BSize],...
    'ButtonPushedFcn',@(GetFileBtn,event)GetFileBtnPushed(GetFileBtn));

bg=uibuttongroup(fig,'Position',[SW*0.75,SH*0.98-BSize,BSize*6,BSize]);
uiradiobutton(bg,'Text','右足','Fontsize',Fsize,'Position',[0,0,BSize*6,BSize]);
uiradiobutton(bg,'Text','左足(左右反転して保存)','Fontsize',Fsize,'Position',[BSize,0,BSize*6,BSize]);

uibutton(fig,'Text','ラベリング','Fontsize',Fsize,'Position',[0,0,BSize*3,BSize],...
    'BackgroundColor','y',...
    'ButtonPushedFcn',@(Label1Btn,event)Label1BtnPushed(Label1Btn));
uibutton(fig,'Text','ラベリング','Fontsize',Fsize,'Position',[BSize*4,0,BSize*3,BSize],...
    'BackgroundColor','m',...
    'ButtonPushedFcn',@(Label2Btn,event)Label2BtnPushed(Label2Btn));
uibutton(fig,'Text','位置リセット','Fontsize',Fsize,'Position',[BSize*8,0,BSize*3,BSize],...
    'ButtonPushedFcn',@(Reset1Btn,event)Reset1BtnPushed(Reset1Btn));
uibutton(fig,'Text','ラベルリセット','Fontsize',Fsize,'Position',[BSize*12,0,BSize*3,BSize],...
    'ButtonPushedFcn',@(Reset2Btn,event)Reset2BtnPushed(Reset2Btn));
uibutton(fig,'Text','保存','Fontsize',Fsize,'Position',[BSize*16,0,BSize*3,BSize],...
    'BackgroundColor',[0.3010 0.7450 0.9330],...
    'ButtonPushedFcn',@(SaveBtn,event)SaveBtnPushed(SaveBtn));
uibutton(fig,'Text','最初から','Fontsize',Fsize,'Position',[BSize*20,0,BSize*3,BSize],...
    'ButtonPushedFcn',@(AllResetBtn,event)AllResetBtnPushed(AllResetBtn));



uibutton(fig,'Text','-10','Fontsize',Fsize,'Position',[SW/6-BSize*3.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Xmove1,event)Xmove1pushed(Xmove1));
uibutton(fig,'Text','-5','Fontsize',Fsize,'Position',[SW/6-BSize*2.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Xmove2,event)Xmove2pushed(Xmove2));
uibutton(fig,'Text','-1','Fontsize',Fsize,'Position',[SW/6-BSize*1.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Xmove3,event)Xmove3pushed(Xmove3));
uibutton(fig,'Text','+1','Fontsize',Fsize,'Position',[SW/6+BSize*0.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Xmove4,event)Xmove4pushed(Xmove4));
uibutton(fig,'Text','+5','Fontsize',Fsize,'Position',[SW/6+BSize*1.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Xmove5,event)Xmove5pushed(Xmove5));
uibutton(fig,'Text','+10','Fontsize',Fsize,'Position',[SW/6+BSize*2.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Xmove6,event)Xmove6pushed(Xmove6));

uibutton(fig,'Text','-10','Fontsize',Fsize,'Position',[SW/6-BSize*3.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Xrotate1,event)Xrotate1pushed(Xrotate1));
uibutton(fig,'Text','-5','Fontsize',Fsize,'Position',[SW/6-BSize*2.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Xrotate2,event)Xrotate2pushed(Xrotate2));
uibutton(fig,'Text','-1','Fontsize',Fsize,'Position',[SW/6-BSize*1.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Xrotate3,event)Xrotate3pushed(Xrotate3));
uibutton(fig,'Text','+1','Fontsize',Fsize,'Position',[SW/6+BSize*0.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Xrotate4,event)Xrotate4pushed(Xrotate4));
uibutton(fig,'Text','+5','Fontsize',Fsize,'Position',[SW/6+BSize*1.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Xrotate5,event)Xrotate5pushed(Xrotate5));
uibutton(fig,'Text','+10','Fontsize',Fsize,'Position',[SW/6+BSize*2.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Xrotate6,event)Xrotate6pushed(Xrotate6));

uibutton(fig,'Text','-10','Fontsize',Fsize,'Position',[SW/2-BSize*3.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Ymove1,event)Ymove1pushed(Ymove1));
uibutton(fig,'Text','-5','Fontsize',Fsize,'Position',[SW/2-BSize*2.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Ymove2,event)Ymove2pushed(Ymove2));
uibutton(fig,'Text','-1','Fontsize',Fsize,'Position',[SW/2-BSize*1.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Ymove3,event)Ymove3pushed(Ymove3));
uibutton(fig,'Text','+1','Fontsize',Fsize,'Position',[SW/2+BSize*0.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Ymove4,event)Ymove4pushed(Ymove4));
uibutton(fig,'Text','+5','Fontsize',Fsize,'Position',[SW/2+BSize*1.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Ymove5,event)Ymove5pushed(Ymove5));
uibutton(fig,'Text','+10','Fontsize',Fsize,'Position',[SW/2+BSize*2.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Ymove6,event)Ymove6pushed(Ymove6));

uibutton(fig,'Text','-10','Fontsize',Fsize,'Position',[SW/2-BSize*3.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Yrotate1,event)Yrotate1pushed(Yrotate1));
uibutton(fig,'Text','-5','Fontsize',Fsize,'Position',[SW/2-BSize*2.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Yrotate2,event)Yrotate2pushed(Yrotate2));
uibutton(fig,'Text','-1','Fontsize',Fsize,'Position',[SW/2-BSize*1.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Yrotate3,event)Yrotate3pushed(Yrotate3));
uibutton(fig,'Text','+1','Fontsize',Fsize,'Position',[SW/2+BSize*0.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Yrotate4,event)Yrotate4pushed(Yrotate4));
uibutton(fig,'Text','+5','Fontsize',30,'Position',[SW/2+BSize*1.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Yrotate5,event)Yrotate5pushed(Yrotate5));
uibutton(fig,'Text','+10','Fontsize',Fsize,'Position',[SW/2+BSize*2.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Yrotate6,event)Yrotate6pushed(Yrotate6));

uibutton(fig,'Text','-10','Fontsize',Fsize,'Position',[SW/1.2-BSize*3.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Zmove1,event)Zmove1pushed(Zmove1));
uibutton(fig,'Text','-5','Fontsize',Fsize,'Position',[SW/1.2-BSize*2.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Zmove2,event)Zmove2pushed(Zmove2));
uibutton(fig,'Text','-1','Fontsize',Fsize,'Position',[SW/1.2-BSize*1.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Zmove3,event)Zmove3pushed(Zmove3));
uibutton(fig,'Text','+1','Fontsize',Fsize,'Position',[SW/1.2+BSize*0.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Zmove4,event)Zmove4pushed(Zmove4));
uibutton(fig,'Text','+5','Fontsize',Fsize,'Position',[SW/1.2+BSize*1.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Zmove5,event)Zmove5pushed(Zmove5));
uibutton(fig,'Text','+10','Fontsize',Fsize,'Position',[SW/1.2+BSize*2.5,SH*0.2,BSize,BSize],...
    'ButtonPushedFcn',@(Zmove6,event)Zmove6pushed(Zmove6));
 
uibutton(fig,'Text','-10','Fontsize',Fsize,'Position',[SW/1.2-BSize*3.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Zrotate1,event)Zrotate1pushed(Zrotate1));
uibutton(fig,'Text','-5','Fontsize',Fsize,'Position',[SW/1.2-BSize*2.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Zrotate2,event)Zrotate2pushed(Zrotate2));
uibutton(fig,'Text','-1','Fontsize',Fsize,'Position',[SW/1.2-BSize*1.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Zrotate3,event)Zrotate3pushed(Zrotate3));
uibutton(fig,'Text','+1','Fontsize',Fsize,'Position',[SW/1.2+BSize*0.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Zrotate4,event)Zrotate4pushed(Zrotate4));
uibutton(fig,'Text','+5','Fontsize',Fsize,'Position',[SW/1.2+BSize*1.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Zrotate5,event)Zrotate5pushed(Zrotate5));
uibutton(fig,'Text','+10','Fontsize',Fsize,'Position',[SW/1.2+BSize*2.5,SH*0.1,BSize,BSize],...
    'ButtonPushedFcn',@(Zrotate6,event)Zrotate6pushed(Zrotate6));

%ファイル選択ボタン動作
    function GetFileBtnPushed(~)
        [file,path]=uigetfile('.mat');
        cd(path);
        load(file,'v','dicominfo');
        filename.Text=[path file];
        
                
        %DICOMセットの1ピクセルあたりの実際の長さ(mm)を読み込み
        spacingX=dicominfo.PixelSpacings(1,1)
        spacingY=dicominfo.PixelSpacings(1,2)
        spacingZ=dicominfo.PatientPositions(2,3)-dicominfo.PatientPositions(1,3)
        %spacingZ=0.5
        
        %1ピクセル=1mmになるように拡大縮小
        vsize=[fix(size(v,1)*spacingX) fix(size(v,2)*spacingY) fix(size(v,3)*spacingZ)]
        V=imresize3(v,vsize);
        
        %144*144*216mmに調整
        V=padarray(V,[144 144 216],-2048,'post');
        vsize=size(V);
        V=V(1:144,1:144,vsize(3)-431:vsize(3)-216);
        %断面を-2048に変更
        V(:,:,1)=-2048;
        
        VR=V;
        VG=V;
        VB=V;
        
        %air=0,tissue=1,trmd=2のラベル作成
        Label=ones(size(V));
        air=(V<0);
        air2=bwareaopen(air,10000,4);
        Label(air2)=0;
        Label2=bwareaopen(Label,1000000,6);
        Label=zeros(size(V));
        Label(Label2)=1;

        CurrentX=[1 0 0]; %Xベクトル初期値
        CurrentY=[0 1 0]; %Yベクトル初期値
        CurrentZ=[0 0 1]; %Zベクトル初期値
        %視点の原点初期値
        Vsize=size(V);
        CurrentO=[fix(Vsize(1)/2) fix(Vsize(2)/2) fix(Vsize(3)*0.75)];
        impreview;
        
        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);

        volshow(Label, Colormap=hsv(256));
    end

%位置リセットボタン動作
    function Reset1BtnPushed(~)
        CurrentX=[1 0 0]; %Xベクトル初期値
        CurrentY=[0 1 0]; %Yベクトル初期値
        CurrentZ=[0 0 1]; %Zベクトル初期値
        %視点の原点初期値
        Vsize=size(V);
        CurrentO=[fix(Vsize(1)/2) fix(Vsize(2)/2) fix(Vsize(3)*0.75)];
        impreview;
        
        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
    end

%ラベルリセットボタン動作
    function Reset2BtnPushed(~)
        VR=V;
        VG=V;
        VB=V;
        
        Label=ones(size(V));
        air=(V<0);
        air2=bwareaopen(air,1000000,6);
        Label(air2)=0;
        impreview;

        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
    end

%ラベルボタン1動作
    function Label1BtnPushed(~)
        zlabelindex=false(size(V)); %視点xy面で切り出したボリューム
        ylabelindex=false(size(V)); %視点xz面で切り出したボリューム
        n=size(V);
        a=CurrentO(1);
        b=CurrentO(2);
        c=CurrentO(3);
        
        g=CurrentY(1);
        h=CurrentY(2);
        i=CurrentY(3);
        
        j=CurrentZ(1);
        k=CurrentZ(2);
        l=CurrentZ(3);
        
        for x=1:n(1)
            for y=1:n(2)
                z=fix(((a-x)*j+(b-y)*k)/l+c);
                z=max([1 z]);
                z=min([z n(3)]);
                zlabelindex(x,y,z:n(3))=true;
            end
        end
        
        for x=1:n(1)
            for z=1:n(3)
                y=fix(((a-x)*g+(c-z)*i)/h+b);
                y=max([1 y]);
                y=min([y n(2)]);
                ylabelindex(x,y:n(2),z)=true;
            end
        end
        
        label=zlabelindex*2+ylabelindex;
        label1index=label==2; %黄色部分のインデックス
        
        volind=Label>=1;
        
        trmdarea=(volind+label1index)==2;
        VR(trmdarea)=0;
        Label(trmdarea)=2;
        impreview;
        

        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
    end

%ラベルボタン2動作
    function Label2BtnPushed(~)
        zlabelindex=false(size(V)); %視点xy面で切り出したボリューム
        ylabelindex=false(size(V)); %視点xz面で切り出したボリューム
        n=size(V);
        a=CurrentO(1);
        b=CurrentO(2);
        c=CurrentO(3);
        
        g=CurrentY(1);
        h=CurrentY(2);
        i=CurrentY(3);
        
        j=CurrentZ(1);
        k=CurrentZ(2);
        l=CurrentZ(3);
        
        for x=1:n(1)
            for y=1:n(2)
                z=fix(((a-x)*j+(b-y)*k)/l+c);
                z=max([1 z]);
                z=min([z n(3)]);
                zlabelindex(x,y,z:n(3))=true;
            end
        end
        
        for x=1:n(1)
            for z=1:n(3)
                y=fix(((a-x)*g+(c-z)*i)/h+b);
                y=max([1 y]);
                y=min([y n(2)]);
                ylabelindex(x,y:n(2),z)=true;
            end
        end
        
        label=zlabelindex*2+ylabelindex;
        label2index=label==3; %マゼンタ部分のインデックス
        
        volind=Label>=1;
        
        trmdarea=(volind+label2index)==2;
        VR(trmdarea)=0;
        Label(trmdarea)=2;
        impreview;
        
        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
    end

%保存ボタン動作
    function SaveBtnPushed(~)
        
        bgp=bg.SelectedObject;
        
        %右足はそのまま保存
        if bgp.Text=="右足"
        
        label=uint8(Label);
        
        vol=zeros(size(V));
        volind=Label>=1;
        vol(volind)=1;
        
        mkdir TrainingVolumeData;
        mkdir TrainingLabelData;

        vfn=strjoin([string(pwd) "TrainingVolumeData" insertBefore(file,".mat","R_vol")],"\");
        lfn=strjoin([string(pwd) "TrainingLabelData" insertBefore(file,".mat","R_label")],"\");
        save(vfn,'vol');
        save(lfn,'label');
        
        %air=Label==0;
        tissue=Label==1;
        trmd=Label==2;
        
        VR=zeros(size(V));
        VG=zeros(size(V));
        VB=zeros(size(V));
        
        VR(tissue)=500;
        VR(trmd)=500;
        VG(tissue)=500;
        VB(trmd)=500;
        
        impreview;
        
        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
        
        %左足は左右反転して保存
        else
        
        label=uint8(Label);
        
        vol=zeros(size(V));
        volind=Label>=1;
        vol(volind)=1;
        
        vol=flip(vol,2);
        label=flip(label,2);
        
        
        mkdir TrainingVolumeData;
        mkdir TrainingLabelData;
        % 'VolumeData'ディレクトリの存在を確認し、存在しない場合のみ作成する
        if ~exist('TrainingVolumeData', 'dir')
            mkdir('VolumeData');
        end
        
        % 'BoneData'ディレクトリの存在を確認し、存在しない場合のみ作成する
        if ~exist('TrainingLabelData', 'dir')
            mkdir('TrainingLabelData');
        end

        vfn=strjoin([string(pwd) "TrainingVolumeData" insertBefore(file,".mat","L_vol")],"\");
        lfn=strjoin([string(pwd) "TrainingLabelData" insertBefore(file,".mat","L_label")],"\");
        save(vfn,'vol');
        save(lfn,'label');
        
        %air=Label==0;
        tissue=Label==1;
        trmd=Label==2;
        
        VR=zeros(size(V));
        VG=zeros(size(V));
        VB=zeros(size(V));
        
        VR(tissue)=500;
        VR(trmd)=500;
        VG(tissue)=500;
        VB(trmd)=500;
        
        impreview;
        
        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
        end
        
    end

%最初からボタン動作
    function AllResetBtnPushed(~)
        VR=V;
        VG=V;
        VB=V;
        
        %air=0,tissue=1,trmd=2のラベル作成
        Label=zeros(size(V));
        Tissue=(V>=0);
        Tissue2=bwareaopen(Tissue,2048,6);
        Label(Tissue2)=1;

        CurrentX=[1 0 0]; %Xベクトル初期値
        CurrentY=[0 1 0]; %Yベクトル初期値
        CurrentZ=[0 0 1]; %Zベクトル初期値
        %視点の原点初期値
        Vsize=size(V);
        CurrentO=[fix(Vsize(1)/2) fix(Vsize(2)/2) fix(Vsize(3)*0.75)];
        impreview;
        
        intensity = [0 20 40 120 220 1024];
        alpha = [0 0 0.15 0.3 0.38 0.5];
        color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
        queryPoints = linspace(min(intensity),max(intensity),256);
        alphamap = interp1(intensity,alpha,queryPoints)';
        colormap = interp1(intensity,color,queryPoints);
%         volshow(Label,Colormap=colormap,Alphamap=alphamap);
        volshow(Label, Colormap=hsv(256));
        
    end


%ボタン動作
    function Xmove1pushed(~)
        CurrentO=CurrentO-CurrentX*10;
        impreview;
    end
    function Xmove2pushed(~)
        CurrentO=CurrentO-CurrentX*5;
        impreview;
    end
    function Xmove3pushed(~)
        CurrentO=CurrentO-CurrentX;
        impreview;
    end
    function Xmove4pushed(~)
        CurrentO=CurrentO+CurrentX;
        impreview;
    end
    function Xmove5pushed(~)
        CurrentO=CurrentO+CurrentX*5;
        impreview;
    end
    function Xmove6pushed(~)
        CurrentO=CurrentO+CurrentX*10;
        impreview;
    end

    function Xrotate1pushed(~)
        rot=axang2rotm([CurrentX -pi/36]);
        CurrentY=CurrentY*rot;
        CurrentZ=CurrentZ*rot;
        impreview;
    end
    function Xrotate2pushed(~)
        rot=axang2rotm([CurrentX -pi/72]);
        CurrentY=CurrentY*rot;
        CurrentZ=CurrentZ*rot;
        impreview;
    end
    function Xrotate3pushed(~)
        rot=axang2rotm([CurrentX -pi/360]);
        CurrentY=CurrentY*rot;
        CurrentZ=CurrentZ*rot;
        impreview;
    end
    function Xrotate4pushed(~)
        rot=axang2rotm([CurrentX pi/360]);
        CurrentY=CurrentY*rot;
        CurrentZ=CurrentZ*rot;
        impreview;
    end
    function Xrotate5pushed(~)
        rot=axang2rotm([CurrentX pi/72]);
        CurrentY=CurrentY*rot;
        CurrentZ=CurrentZ*rot;
        impreview;
    end
    function Xrotate6pushed(~)
        rot=axang2rotm([CurrentX pi/36]);
        CurrentY=CurrentY*rot;
        CurrentZ=CurrentZ*rot;
        impreview;
    end

    function Ymove1pushed(~)
        CurrentO=CurrentO-CurrentY*10;
        impreview;
    end
    function Ymove2pushed(~)
        CurrentO=CurrentO-CurrentY*5;
        impreview;
    end
    function Ymove3pushed(~)
        CurrentO=CurrentO-CurrentY;
        impreview;
    end
    function Ymove4pushed(~)
        CurrentO=CurrentO+CurrentY;
        impreview;
    end
    function Ymove5pushed(~)
        CurrentO=CurrentO+CurrentY*5;
        impreview;
    end
    function Ymove6pushed(~)
        CurrentO=CurrentO+CurrentY*10;
        impreview;
    end
 
    function Yrotate1pushed(~)
        rot=axang2rotm([CurrentY -pi/36]);
        CurrentZ=CurrentZ*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Yrotate2pushed(~)
        rot=axang2rotm([CurrentY -pi/72]);
        CurrentZ=CurrentZ*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Yrotate3pushed(~)
        rot=axang2rotm([CurrentY -pi/360]);
        CurrentZ=CurrentZ*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Yrotate4pushed(~)
        rot=axang2rotm([CurrentY pi/360]);
        CurrentZ=CurrentZ*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Yrotate5pushed(~)
        rot=axang2rotm([CurrentY pi/72]);
        CurrentZ=CurrentZ*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Yrotate6pushed(~)
        rot=axang2rotm([CurrentY pi/36]);
        CurrentZ=CurrentZ*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end

    function Zmove1pushed(~)
        CurrentO=CurrentO-CurrentZ*10;
        impreview;
    end
    function Zmove2pushed(~)
        CurrentO=CurrentO-CurrentZ*5;
        impreview;
    end
    function Zmove3pushed(~)
        CurrentO=CurrentO-CurrentZ;
        impreview;
    end
    function Zmove4pushed(~)
        CurrentO=CurrentO+CurrentZ;
        impreview;
    end
    function Zmove5pushed(~)
        CurrentO=CurrentO+CurrentZ*5;
        impreview;
    end
    function Zmove6pushed(~)
        CurrentO=CurrentO+CurrentZ*10;
        impreview;
    end
 
    function Zrotate1pushed(~)
        rot=axang2rotm([CurrentZ -pi/36]);
        CurrentY=CurrentY*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Zrotate2pushed(~)
        rot=axang2rotm([CurrentZ -pi/72]);
        CurrentY=CurrentY*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Zrotate3pushed(~)
        rot=axang2rotm([CurrentZ -pi/360]);
        CurrentY=CurrentY*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Zrotate4pushed(~)
        rot=axang2rotm([CurrentZ pi/360]);
        CurrentY=CurrentY*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Zrotate5pushed(~)
        rot=axang2rotm([CurrentZ pi/72]);
        CurrentY=CurrentY*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end
    function Zrotate6pushed(~)
        rot=axang2rotm([CurrentZ pi/36]);
        CurrentY=CurrentY*rot;
        CurrentX=CurrentX*rot;
        impreview;
    end



%プレビュー画像表示
    function impreview(~)
        Vr=VR;
        Vg=VG;
        Vb=VB;
        
        n=size(V);
        a=CurrentO(1);
        b=CurrentO(2);
        c=CurrentO(3);
        
        d=CurrentX(1);
        e=CurrentX(2);
        f=CurrentX(3);
        
        g=CurrentY(1);
        h=CurrentY(2);
        i=CurrentY(3);
        
        j=CurrentZ(1);
        k=CurrentZ(2);
        l=CurrentZ(3);
        
        %縁の色塗り
        Vg(1:n(1),1:10,1:n(3))=500;
        Vr(1:n(1),1:n(2),n(3)-10:n(3))=500;
        Vb(1:n(1),n(2)-10:n(2),1:n(3))=500;
        
        %視点のX,Y,Z座標軸を描画
        %ボリュームの範囲を超えないように
        for x=1:n(1)
            y=fix((x-a)*e/d+b);
            y=max([2 y]);
            y=min([y n(2)-1]);
            z=fix((x-a)*f/d+c);
            z=max([2 z]);
            z=min([z n(3)-1]);
            Vr(x,y-1:y+1,z-1:z+1)=500;
        end
        
        for y=1:n(2)
            z=fix((y-b)*i/h+c);
            z=max([2 z]);
            z=min([z n(3)-1]);
            x=fix((y-b)*g/h+a);
            x=max([2 x]);
            x=min([x n(1)-1]);
            Vg(x-1:x+1,y,z-1:z+1)=500;
        end
        
        for z=1:n(3)
            x=fix((z-c)*j/l+a);
            x=max([2 x]);
            x=min([x n(1)-1]);
            y=fix((z-c)*k/l+b);
            y=max([2 y]);
            y=min([y n(2)-1]);
            Vb(x-1:x+1,y-1:y+1,z)=500;
        end
        
        
        %obliquesliceの挙動がおかしいので法線ベクトルのXY座標を逆転
        %左手系？
        %アップデートで不要になるかも
        CurrentO1=[CurrentO(2) CurrentO(1) CurrentO(3)];
        CurrentX1=[CurrentX(2) CurrentX(1) CurrentX(3)];
        CurrentY1=[CurrentY(2) CurrentY(1) CurrentY(3)];
        CurrentZ1=[CurrentZ(2) CurrentZ(1) CurrentZ(3)];        
        
        sliceXr=obliqueslice(Vr,CurrentO1,CurrentX1); %斜体スライスを取得
        sliceXg=obliqueslice(Vg,CurrentO1,CurrentX1);
        sliceXb=obliqueslice(Vb,CurrentO1,CurrentX1);
        
        sliceYr=obliqueslice(Vr,CurrentO1,CurrentY1);
        sliceYg=obliqueslice(Vg,CurrentO1,CurrentY1);
        sliceYb=obliqueslice(Vb,CurrentO1,CurrentY1);
        
        sliceZr=obliqueslice(Vr,CurrentO1,CurrentZ1);
        sliceZg=obliqueslice(Vg,CurrentO1,CurrentZ1);
        sliceZb=obliqueslice(Vb,CurrentO1,CurrentZ1);
        
        
        imageXr=mat2gray(sliceXr,[0 300]); %斜体スライスをグレースケールに変換
        imageXg=mat2gray(sliceXg,[0 300]);
        imageXb=mat2gray(sliceXb,[0 300]);
        imageYr=mat2gray(sliceYr,[0 300]);
        imageYg=mat2gray(sliceYg,[0 300]);
        imageYb=mat2gray(sliceYb,[0 300]);
        imageZr=mat2gray(sliceZr,[0 300]);
        imageZg=mat2gray(sliceZg,[0 300]);
        imageZb=mat2gray(sliceZb,[0 300]);
        
        imageX=cat(3,imageXr,imageXg,imageXb);
        imageY=cat(3,imageYr,imageYg,imageYb);
        imageZ=cat(3,imageZr,imageZg,imageZb);
        
        imageXsize=size(imageX);
        imageYsize=size(imageY);
        imageZsize=size(imageZ);
        
        imageXarea.ImageSource=imageX(1:min(imageXsize(1:2)),1:min(imageXsize(1:2)),:);
        %imageXarea.ImageSource=imageX;
        
        imageYarea.ImageSource=imageY(1:min(imageYsize(1:2)),1:min(imageYsize(1:2)),:);
        %imageYarea.ImageSource=imageY;
        
        imageZarea.ImageSource=imageZ(1:min(imageZsize(1:2)),1:min(imageZsize(1:2)),:);
    end

end