function CTrimmer20
%ウィンドウサイズ取得
r=groot;
SW=r.ScreenSize(3);
SH=r.ScreenSize(4);

%ウィンドウ表示
fig=uifigure('Name','CTrimmer Ver.2.0','Position',[0,0,SW,SH*0.97]);

%変数初期値
path='dicomデータセットの格納されているディレクトリを選択'; %dicomファイルの置いてあるパス
VV=0;

X1=1; %トリミング位置
X2=512;
Y1=1;
Y2=512;
Z1=1;
Z2=512;

XYimage=0; %プレビュー画像
YZimage=0;
ZXimage=0;

dicominfo=0; %dicomファイルの情報

savepath='トリミング済みCTデータの保存先を選択'; %保存先パス
savename='保存名';


%UI表示
uibutton(fig,'push','Text','dicomフォルダ選択','Position',...
    [SW*0.05,SH*0.9,SW*0.2,SH*0.05],...
    'ButtonPushedFcn',@(getdirbtn,event) getdir(getdirbtn));
panel1=uipanel(fig,'Position',[SW*0.05,SH*0.8,SW*0.4,SH*0.05]);
textarea1=uilabel(panel1,'Position',[20,0,SW*0.4,SH*0.05]);
textarea1.Text=string(path);
uibutton(fig,'push','Text','保存先フォルダ選択','Position',...
    [SW*0.05,SH*0.7,SW*0.2,SH*0.05],...
    'ButtonPushedFcn',@(getdirbtn2,event) getdir2(getdirbtn2));
panel2=uipanel(fig,'Position',[SW*0.05,SH*0.6,SW*0.4,SH*0.05]);
textarea2=uilabel(panel2,'Position',[20,0,SW*0.4,SH*0.05]);
textarea2.Text=string(savepath);
uibutton(fig,'push','Text','保存','Position',...
    [SW*0.75,SH*0.7,SW*0.2,SH*0.05],...
    'ButtonPushedFcn',@(savebtn,event) sv(savebtn));
textarea3=uitextarea(fig,'Position',[SW*0.55,SH*0.7,SW*0.15,SH*0.05],...
    'ValueChangedFcn',@(textarea3,event) textentered(textarea3));
textarea3.Value=string(savename);

axXY=uiimage('Parent',fig,'Position',[0,0,SW/3,SW/3]);
axYZ=uiimage('Parent',fig,'Position',[SW/3,0,SW/3,SW/3]);
axZX=uiimage('Parent',fig,'Position',[SW/1.5,0,SW/3,SW/3]);

X1sld=uislider('Parent',fig,'Position',[SW*0.1,SH*0.05,SW*0.3,3],...
    'ValueChangedFcn',@(X1sld,event) X1update(X1sld));
X1sld.Limits=[0 512];
X2sld=uislider('Parent',fig,'Position',[SW*0.1,SH*0.45,SW*0.3,3],...
    'ValueChangedFcn',@(X2sld,event) X2update(X2sld));
X2sld.Limits=[0 512];
X2sld.Value=512;
Y1sld=uislider('Parent',fig,'Orientation','vertical',...
    'Position',[SW*0.05,SH*0.05,3,SH*0.4],...
    'ValueChangedFcn',@(Y1sld,event) Y1update(Y1sld));
Y1sld.Limits=[-512 0];
Y2sld=uislider('Parent',fig,'Orientation','vertical',...
    'Position',[SW*0.45,SH*0.05,3,SH*0.4],...
    'ValueChangedFcn',@(Y2sld,event) Y2update(Y2sld));
Y2sld.Limits=[-512 0];
Y2sld.Value=-512;
Z1sld=uislider('Parent',fig,'Position',[SW*0.55,SH*0.05,SW*0.4,3],...
    'ValueChangedFcn',@(Z1sld,event) Z1update(Z1sld));
Z1sld.Limits=[0 512];
Z2sld=uislider('Parent',fig,'Position',[SW*0.55,SH*0.95,SW*0.4,3],...
    'ValueChangedFcn',@(Z2sld,event) Z2update(Z2sld));
Z2sld.Limits=[0 512];
Z2sld.Value=512;

%ディレクトリ選択ボタン動作
    function getdir(~)
        dirname=uigetdir;
        path=dirname;
        textarea1.Text=string(path);
        
        %読み取りファイル定義
        list=dir(dirname);
        listcell=struct2cell(list);
        filenamelist=listcell(1,:);
        filenamelist2=append(dirname,'\',filenamelist); %Macでは/、Windowsでは\
        filenamelist3=rot90(filenamelist2,3);
        listsize=size(filenamelist,2);
        
        Z1sld.Limits=[0 listsize-2];
        Z2sld.Limits=[0 listsize-2];
        Z2sld.Value=listsize-2;
        Z2=listsize-2;
        X1=1;
        X2=512;
        Y1=1;
        Y2=512;
        Z1=1;
        X1sld.Value=0;
        X2sld.Value=X2;
        Y1sld.Value=0;
        Y2sld.Value=-Y2;
        Z1sld.Value=-0;
        Z2sld.Value=Z2;
        
        [a,dicominfo]=dicomreadVolume(filenamelist3(3:4));
        V=dicomread(cell2mat(filenamelist3(3)));
        
        for n=4:listsize
            V=cat(3,V,dicomread(cell2mat(filenamelist3(n))));           
        end
        
        VV=V;
        
        XYimage=(squeeze(mean(V,3)+1024))/2048;
        YZimage=(squeeze(mean(V,2)+1024))/1024;
        ZXimage=(squeeze(mean(V,1)+1024))/1024;
        
        impreview;
        
        v1=V>-100 & V<150;
        volshow(v1);
        
    end

%保存先フォルダ選択ボタン動作
    function getdir2(~)
        dirname=uigetdir;
        savepath=[dirname];
        textarea2.Text=string(savepath);
        cd(savepath)
    end

%保存名入力時動作
    function textentered(~)
        savename=string(textarea3.Value);
    end

%X1スライダー操作
    function X1update(~)
        X1=round(X1sld.Value);
        impreview;
    end

%X2スライダー操作
    function X2update(~)
        X2=round(X2sld.Value);
        impreview;
    end

%Y1スライダー操作
    function Y1update(~)
        Y1=-round(Y1sld.Value);
        impreview;
    end

%Y2スライダー操作
    function Y2update(~)
        Y2=round(-Y2sld.Value);
        impreview;
    end

%Z1スライダー操作
    function Z1update(~)
        Z1=round(Z1sld.Value);
        impreview;
    end

%Z2スライダー操作
    function Z2update(~)
        Z2=round(Z2sld.Value);
        impreview;
    end

%保存ボタン操作
    function sv(~)

       v=VV(Y1:Y2,X1:X2,Z1:Z2);
       
       volshow(imbinarize(v,0.5));
       
       save(savename,'v','dicominfo');
       
       dicominfo.PixelSpacings
       size(v).*dicominfo.PixelSpacings(1);
       
    end

%プレビュー画像表示させる関数
    function impreview(~)
                
        previewXY=insertShape(XYimage,'Rectangle',...
            [X1 Y1 X2-X1 Y2-Y1],...
            'Color','blue','LineWidth',1);
        axXY.ImageSource=previewXY;
        
        previewYZ=insertShape(YZimage,'Rectangle',...
            [Z1 Y1 Z2-Z1 Y2-Y1],...
            'Color','red','LineWidth',1);
        axYZ.ImageSource=previewYZ;
        
        previewZX=insertShape(ZXimage,'Rectangle',...
            [Z1 X1 Z2-Z1 X2-X1],...
            'Color','green','LineWidth',1);
        axZX.ImageSource=previewZX;
        
    end


end