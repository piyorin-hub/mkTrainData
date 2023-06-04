function TrainDataMakerVer2
%学習用データ作成アプリ
%データ読み込み時点で1ピクセル＝1mm、144*144*288に変換
%保存時に1ピクセル＝2mm、772*72*144に変換

%ウィンドウのサイズ読み込み
r=groot;
SW=r.ScreenSize(3);
SH=r.ScreenSize(4)-30;

%変数初期値
thA=-100;
thB=140;
thC=300;
thD=500000;
thE=500000;
thF=40000;
thG=500000;
thH=100000;
thI=10000;
x=1;
y=1;
z=1;
v=zeros([2 2 2]);

T=0;
B=0;
H=0;
file='0';
path='0';

%UI表示
fig=uifigure('Name','学習データ作成アプリ', ...
    'Position',[0,0,SW,SH]);
panelA=uipanel(fig,'Position',[0,0,SW/3,SH]);
panelB=uipanel(fig,'Position',[SW/3,0,SW/1.5,SH]);
intensity = [0 20 40 120 220 1024];
alpha = [0 0 0.15 0.3 0.38 0.5];
color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';
colormap = interp1(intensity,color,queryPoints);
hVol = volshow(v, Colormap=colormap, Alphamap=alphamap);
hVol.Colormap=gray;

uibutton(panelA,'text','選択',...
    'Position',[SW/6-SW/20,SH*0.9,SW/10,SH/20],...
    'ButtonPushedFcn',@(getfilebtn,event)getfile(getfilebtn));
uibutton(panelA,'text','決定',...
    'Position',[SW/6-SW/20,SH*0.35,SW/10,SH/20],...
    'ButtonPushedFcn',@(startbtn,event)start(startbtn));
uibutton(panelA,'text','学習用データエクスポート',...
    'Position',[SW/6-SW/20,SH*0.1,SW/10,SH/20],...
    'ButtonPushedFcn',@(savebtn,event)traindataexport(savebtn));

uilabel(panelA,"Text","空気-軟部組織しきい値","Position",[SW/20,SH*0.85,SW/10,SH/40]);
textA=uitextarea(panelA,'Position',[SW/6,SH*0.85,SW/10,SH/40],...
    'ValueChangedFcn',@(textA,event) textAEntered(textA));
textA.Value=num2str(thA);

uilabel(panelA,"Text","軟部組織-角質しきい値","Position",[SW/20,SH*0.8,SW/10,SH/40]);
textB=uitextarea(panelA,'Position',[SW/6,SH*0.8,SW/10,SH/40],...
    'ValueChangedFcn',@(textB,event) textBEntered(textB));
textB.Value=num2str(thB);

uilabel(panelA,"Text","角質-骨しきい値","Position",[SW/20,SH*0.75,SW/10,SH/40]);
textC=uitextarea(panelA,'Position',[SW/6,SH*0.75,SW/10,SH/40],...
    'ValueChangedFcn',@(textC,event) textCEntered(textC));
textC.Value=num2str(thC);

uilabel(panelA,"Text","mm^3以下の分離した軟部組織を削除","Position",[SW/6,SH*0.7,SW/6,SH/40]);
textD=uitextarea(panelA,'Position',[SW/20,SH*0.7,SW/10,SH/40],...
    'ValueChangedFcn',@(textD,event) textDEntered(textD));
textD.Value=num2str(thD);

uilabel(panelA,"Text","mm^3以下の軟部組織内の低CT値領域を削除","Position",[SW/6,SH*0.65,SW/6,SH/40]);
textE=uitextarea(panelA,'Position',[SW/20,SH*0.65,SW/10,SH/40],...
    'ValueChangedFcn',@(textE,event) textEEntered(textE));
textE.Value=num2str(thE);

uilabel(panelA,"Text","mm^3以下の分離した角質を削除","Position",[SW/6,SH*0.6,SW/6,SH/40]);
textF=uitextarea(panelA,'Position',[SW/20,SH*0.6,SW/10,SH/40],...
    'ValueChangedFcn',@(textF,event) textFEntered(textF));
textF.Value=num2str(thF);

uilabel(panelA,"Text","mm^3以下の角質内の低CT値領域を削除","Position",[SW/6,SH*0.55,SW/6,SH/40]);
textG=uitextarea(panelA,'Position',[SW/20,SH*0.55,SW/10,SH/40],...
    'ValueChangedFcn',@(textG,event) textGEntered(textG));
textG.Value=num2str(thG);

uilabel(panelA,"Text","mm^3以下の分離した骨を削除","Position",[SW/6,SH*0.5,SW/6,SH/40]);
textH=uitextarea(panelA,'Position',[SW/20,SH*0.5,SW/10,SH/40],...
    'ValueChangedFcn',@(textH,event) textHEntered(textH));
textH.Value=num2str(thH);

uilabel(panelA,"Text","mm^2以下の骨内の低CT値領域を削除(各スライス)","Position",[SW/6,SH*0.45,SW/6,SH/40]);
textI=uitextarea(panelA,'Position',[SW/20,SH*0.45,SW/10,SH/40],...
    'ValueChangedFcn',@(textI,event) textIEntered(textI));
textI.Value=num2str(thI);

bg=uibuttongroup(panelA,'Position',[SW/20,SH*0.2,SW/4,SH*0.1]);
uiradiobutton(bg,'Text','右足','Position',[SW/20,0,SW/6,SH*0.1]);
uiradiobutton(bg,'Text','左足(左右反転して保存)','Position',[SW/6-SW/20,0,SW/6,SH*0.1]);

    function getfile(~)
        [file,path]=uigetfile;
        load([path file],'v','dicominfo');
%         print(file);
        cd(path);
        x=dicominfo.PixelSpacings(1,1);
        y=dicominfo.PixelSpacings(2,1);
        z=dicominfo.PatientPositions(2,3)-dicominfo.PatientPositions(1,3);

        %z=0.5

        %1ピクセル=1mmになるように拡大縮小
        vsize=[fix(size(v,1)*x) fix(size(v,2)*y) fix(size(v,3)*z)];
        v=imresize3(v,vsize);
        x=1;
        y=1;
        z=1;

        %144*144*288mmに調整
        v=padarray(v,[144 144 288],-2048,'post');
        vsize=size(v);
        v=v(1:144,1:144,vsize(3)-575:vsize(3)-288);

        orthosliceViewer(v,'Parent',panelB);
        hVol.Data = v;
%         setVolume(hVol,v);
    end

    function start(~)
        [T,B,H]=makeTBH(v,x,y,z,thA,thB,thC,thD,thE,thF,thG,thH,thI);
        im=(double(T)+double(H)+double(B)*2)/4;
        orthosliceViewer(im,'Parent',panelB,'Colormap',gray);
%         setVolume(hVol,im);
        hVol.Data = im;
    end

    function traindataexport(~)
        bgp=bg.SelectedObject;
        % 'VolumeData'ディレクトリの存在を確認し、存在しない場合のみ作成する
        if ~exist('VolumeData', 'dir')
            mkdir('VolumeData');
        end
        
        % 'BoneData'ディレクトリの存在を確認し、存在しない場合のみ作成する
        if ~exist('BoneData', 'dir')
            mkdir('BoneData');
        end
        
        %右足はそのまま保存
        if bgp.Text=="右足"
            Vfn=insertBefore(file,".mat","_R_vol");
            Vfn=strjoin([string(pwd) 'VolumeData' Vfn],'/');
            vol=uint8(T);
            % 1mm->2mm
%             vol=vol(1:2:143,1:2:143,1:2:287);
            save(Vfn,'vol');
            Bfn=insertBefore(file,".mat","_R_bone");
            Bfn=strjoin([string(pwd) 'BoneData' Bfn],'/');
            bone=uint8(double(T)+double(H)*2+double(B));
            bone4=bone==4;
            bone(bone4)=3;
%             bone=bone(1:2:143,1:2:143,1:2:287);
            save(Bfn,'bone');
            im=cat(1,vol,bone);
%             setVolume(hVol,im);
            hVol.Data = im;

        %左足は左右反転して保存
        else
            Vfn=insertBefore(file,".mat","_L(rev)_vol");
            Vfn=strjoin([string(pwd) 'VolumeData' Vfn],'/');
            vol=uint8(T);
%             vol=vol(1:2:143,1:2:143,1:2:287);

            vol=flip(vol,2);

            save(Vfn,'vol');
            Bfn=insertBefore(file,".mat","_L(rev)_bone");
            Bfn=strjoin([string(pwd) 'BoneData' Bfn],'/');
            bone=uint8(double(T)+double(H)*2+double(B));
            bone4=bone==4;
            bone(bone4)=3;
%             bone=bone(1:2:143,1:2:143,1:2:287);

            bone=flip(bone,2);

            save(Bfn,'bone');
            im=cat(1,vol,bone);
%             setVolume(hVol,im);
            hVol.Data = im;
        end
    end

    function textAEntered(~)
        thA=str2double(cell2mat(textA.Value));
    end

    function textBEntered(~)
        thB=str2double(cell2mat(textB.Value));
    end

    function textCEntered(~)
        thC=str2double(cell2mat(textC.Value));
    end

    function textDEntered(~)
        thD=str2double(cell2mat(textD.Value));
    end

    function textEEntered(~)
        thE=str2double(cell2mat(textE.Value));
    end

    function textFEntered(~)
        thF=str2double(cell2mat(textF.Value));
    end

    function textGEntered(~)
        thG=str2double(cell2mat(textG.Value));
    end

    function textHEntered(~)
        thH=str2double(cell2mat(textH.Value));
    end

    function textIEntered(~)
        thI=str2double(cell2mat(textI.Value));
    end

end

function [T,B,H]=makeTBH(v,x,y,z,a,b,c,d,e,f,g,h,i)
        T=v>a;
        T=bwareaopen(T,round(d/(x*y*z)),6);
        Ta=T==0;
        Ta=bwareaopen(Ta,round(e/(x*y*z)),6);
        T=Ta==0;

        A=v<b;
        H=v;
        H(A)=0;
        B=H>c;
        H(B)=0;
        H=H>b;

        H=bwareaopen(H,round(f/(x*y*z)),6);

        Tb=ones(size(v));
        Tb(B)=0;
        Tb=bwareaopen(Tb,round(i*x*y),4);
        B=Tb==0;
        B=bwareaopen(B,round(h*x*y*z),6);

        SE=strel("sphere",round(3/x));
        Hd=imdilate(H,SE);
        A=T==0;
        Ad=imdilate(A,SE);
        Hu=double(T)+double(Hd)+double(Ad);
        Hv=Hu==3;
        H(Hv)=1;

        Tb=T;
        Tb(H)=0;
        Tb=bwareaopen(Tb,round(g/(x*y*z)),6);
        H=T;
        H(Tb)=0;
    end