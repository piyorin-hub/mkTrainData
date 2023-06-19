% 1. ボリュームデータを準備する（仮の例）
volume_data = randn(100, 100, 100); % 100x100x100のランダムなボリュームデータ

% 2. ボリュームを表示する
volshow(volume_data);

% 3. 平面を作成する
plane_normal = [0 0 1]; % 平面の法線ベクトル（例: z軸方向）
plane_point = [50 50 50]; % 平面上の1点の座標（例: (50, 50, 50)）
plane_color = [1 0 0]; % 平面の色（例: 赤）
plane_opacity = 0.5; % 平面の透明度（例: 半透明）
% 
% volshow('Plane', plane_normal, plane_point, 'Color', plane_color, 'Opacity', plane_opacity);
volshow('Plane', 'Parent', gca, 'VolumeData', plane_normal, plane_point, 'Color', plane_color, 'Opacity', plane_opacity);