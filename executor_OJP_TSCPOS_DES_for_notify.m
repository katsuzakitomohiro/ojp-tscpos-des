%% 需要側エネルギーシステムの技術選択・設備容量計画・運転計画の同時最適化の実行器
% *Executor of Optimal Joint Planning of Technology Selection, Capacities Planning, 
% and Operation Scheduling for Demand-Side Energy System*
%% *動作環境*
%% 
% * MATLAB R2024b
% * Optimization Toolbox
% * Parallel Computing Toolbox
% * (Gurobi Optimizer V. 12.0)
%% ヘッダー

close all; % 図を全て閉じる

zz_setNotify = 'on'; % [-]
switch zz_setNotify
    case 'on'
        clearvars -except fileName token url options % ワークスペースから変数名fileName，token，url，optionsを除いてアイテムを削除
        % LINE通知を行う際は，zz_setNotifyをonにした後，このファイルをexecutor_OJP_TSCPOS_DESで保存したのち，下記のコマンドをコマンドウィンドウで実行
        % executor_simulation_exit_notification('executor_OJP_TSCPOS_DES')
    case 'off'
        clear; % ワークスペースからアイテムを削除
        % LINE通知を行わない際は，zz_setNotifyをoffにした後，下記のコマンドをコマンドウィンドウで実行
        % executor_OJP_TSCPOS_DES
        % (コマンドウィンドウで実行しない場合，mlxの出力ウィンドウにログ等が大量に表示され，フリーズする可能性があるため，コマンドウィンドウからの実行を推奨)
end

disp(['Start executing script at ',char(datetime('now'))]);
zz_scriptStartTime = tic; % スクリプト実行時間測定開始[-]
%% 実行の設定

zz_setType = 'All cases'; % [-]
switch zz_setType
    case 'One case'
        zz_setCaseName = '1ax'; % [-]
end
zz_setEnergyAmountRateUnitPrice = 'static'; % [-] % 売買電料金単価(電力量料金単価と買取料金単価)の設定
zz_setCO2emissionFactor = 'static'; % [-] % CO2排出係数の設定
zz_setMaxTime = 18000; % [second] % 10分以上推奨(長期間シミュレーションをするとメモリエラーになることがあるため注意)
zz_setDisplay = 'iter'; % [-] % iter推奨(最適化のログをコマンドウィンドウに表示する際にはiter)
zz_setSolver = 'Gurobi'; % [-] % Gurobi推奨
switch zz_setSolver
    case 'Gurobi'
        zz_setSolverVer = '12.0.2'; % [-] % 12.0.2推奨
    case 'MATLAB'
        zz_setSolverVer = 'R2024b'; % [-] % R2024b推奨
end
zz_setExeOptim = 'on'; % [-] % offで実行する場合はresultが得られている場合のみ実行可能
zz_setFigureMake = 'on'; % [-] % All casesのすべての図作成にはかなり時間がかかる
switch zz_setFigureMake
    case 'on'
        zz_setMakeEachTimeSeriesData = 'on'; % [-] % 各時系列データの図作成の有無の設定
        zz_setMakeEachTimeSeriesDataConfiguration = 'on'; % [-] % 各時系列データの主要な構成の図作成の有無の設定
        zz_setMakeCorrelationAnalysisCOP = 'on'; % [-] % 成績係数に関する相関関係分析用の図作成の有無の設定
        zz_setMakeMIPGapConvergenceHistory = 'on'; % [-] % MIPGapの収束履歴の図作成の有無の設定

        zz_setTitleDisplay = 'off'; % [-] % off推奨(図の保存スタイル(zz_figStyle)が'paper'または'presentation'のときに設定が有効('display'のときは設定に関係なく強制的にタイトルが付く))
        zz_setTitleCaseDisplay = 'on'; % [-] % on推奨(図の保存スタイル(zz_figStyle)が'paper'または'presentation'のときに設定が有効('display'のときは設定に関係なく強制的にケースが付く))
        zz_setLegendDisplay = 'off'; % [-] % off推奨(図の保存スタイル(zz_figStyle)が'paper'または'presentation'のときに設定が有効('display'のときは設定に関係なく強制的に凡例が付く))
        zz_setXAxisSecondaryLabelDisplay = 'off'; % [-] % off推奨(onの場合，グラフの右下に日付を表示)
        zz_setYLim = 'fixed for paper condition'; % [-] % 'fixed for paper condition'推奨(パラメータや外乱予測値を変える場合はauto推奨)
end
%% ケース分析器の実行

switch zz_setExeOptim
    case 'on'
        switch zz_setType
            case 'All cases'
                zz_setAllCaseName = {'1ax','1ay','1bx','1by','2ax','2ay','2bx','2by'};
                disp(['Start executing parfor at ',char(datetime('now'))]);
                zz_parforStartTime = tic; % parfor実行時間測定開始[-]
                zz_tempTime = cell(length(zz_setAllCaseName),1);
                parfor i = 1:length(zz_setAllCaseName)
                    zz_setCaseName = zz_setAllCaseName{i}; %#ok<PFTUSW>

                    disp(['Start executing Case ',zz_setCaseName]);
                    zz_caseAnalysisStartTime = tic; % Case分析実行時間測定開始[-]

                    analyzer_case_OJP_TSCPOS_DES(zz_setCaseName,zz_setEnergyAmountRateUnitPrice,zz_setCO2emissionFactor,zz_setMaxTime,zz_setDisplay,zz_setSolver,zz_setSolverVer);

                    zz_tempTime{i} = toc(zz_caseAnalysisStartTime); % Case分析実行時間測定終了[-]
                    disp(['Finish executing Case ',zz_setCaseName]);
                end
                for i = 1:length(zz_setAllCaseName)
                    zz_setCaseName = zz_setAllCaseName{i};
                    zz_executeTime.(['case_',zz_setCaseName]) = zz_tempTime{i};
                end
                zz_executeTime.parfor = toc(zz_parforStartTime); % parfor実行時間測定終了[-]
                disp(['Finish executing parfor at ',char(datetime('now'))]);
                disp(['Execution time for parfor is ',num2str(zz_executeTime.parfor),' seconds']);

            case 'One case'
                disp(['Start executing Case ',zz_setCaseName]);
                zz_caseAnalysisStartTime = tic; % Case分析実行時間測定開始[-]
%%
                [zz_case,zz_parameter,zz_disturbance,zz_prob,zz_result] = analyzer_case_OJP_TSCPOS_DES(zz_setCaseName,zz_setEnergyAmountRateUnitPrice,zz_setCO2emissionFactor,zz_setMaxTime,zz_setDisplay,zz_setSolver,zz_setSolverVer); % この行はスクリプトにおいて表示のためにあえてセクションを分割
%%
                zz_executeTime.(['case_',zz_setCaseName]) = toc(zz_caseAnalysisStartTime); % Case分析実行時間測定終了[-]
                disp(['Finish executing Case ',zz_setCaseName]);
                disp(['Execution time for Case ',zz_setCaseName,' is ',num2str(zz_executeTime.(['case_',zz_setCaseName])),' seconds']);
        end
    case 'off'
        switch zz_setType
            case 'All cases'
                zz_setAllCaseName = {'1ax','1ay','1bx','1by','2ax','2ay','2bx','2by'};
        end
end
%% 結果の整理

switch zz_setExeOptim
    case 'on'
        clear zz_setEnergyAmountRateUnitPrice
        clear zz_setCO2emissionFactor;
        clear zz_setMaxTime;
        clear zz_setDisplay;
        clear zz_setSolver;
        clear zz_setSolverVer;
        clear zz_parforStartTime;
        clear zz_tempTime;
        clear zz_caseAnalysisStartTime;

        switch zz_setType
            case 'All cases'
                for i = 1:length(zz_setAllCaseName)
                    zz_allCases.(['case_',zz_setAllCaseName{i}]) = load(fullfile('result',['case_',zz_setAllCaseName{i}],'workspace.mat'));
                end
                for i = 1:length(zz_setAllCaseName)
                    if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                        zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct = zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.capAreaCostCo2.capAreaCostCo2.struct;
                        zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct = rmfield(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct,'value');
                        break
                    end
                end
                for i = 1:length(zz_setAllCaseName)
                    if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                        [zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct.(['case_',zz_setAllCaseName{i}])] = deal(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.capAreaCostCo2.capAreaCostCo2.struct.value);
                    else
                        if isfield(zz_allCases,'summary')
                            for j = 1:size(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct,2)
                                zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct(j).(['case_',zz_setAllCaseName{i}]) = '';
                            end
                        else
                            break
                        end
                    end
                end
                if isfield(zz_allCases,'summary')
                    zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct))'; % 容量面積コストCO2セル配列(容量と面積は少数第二位以下切り上げ，コストは小数点以下切り捨て，CO2排出量は少数第三位以下切り捨て)[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct(1:10); % ケース解情報構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.struct))'; % ケース解情報セル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.cap.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,11:27]); % 容量構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.cap.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.cap.struct))'; % 容量セル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,28:37]); % 面積電気料金構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.struct))'; % 面積電気料金セル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,38:47]); % ガス上下水道料金構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.struct))'; % ガス上下水道料金セル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,49:66]); % 設備減価償却費構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.struct))'; % 設備減価償却費セル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,37,42,47,48,66,67]); % 総コスト構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.struct))'; % 総コストセル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,76:93]); % 設備減価償却CO2排出量構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.struct))'; % 設備減価償却CO2排出量セル配列[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,68:75,93,94]); % 総CO2排出量構造体[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.struct))'; % 総CO2排出量セル配列[any]

                    for i = 1:length(zz_setAllCaseName)
                        if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                            zz_allCases.summary.timeSeriesData.discreteTimeData.timetable.(['case_',zz_setAllCaseName{i}]) = zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.timeSeriesData.discreteTimeData.timetable;
                            zz_allCases.summary.timeSeriesData.discreteTimeData.cell.(['case_',zz_setAllCaseName{i}]) = zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.timeSeriesData.discreteTimeData.cell;
                            zz_allCases.summary.timeSeriesData.continuousTimeData.timetable.(['case_',zz_setAllCaseName{i}]) = zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.timeSeriesData.continuousTimeData.timetable;
                            zz_allCases.summary.timeSeriesData.continuousTimeData.cell.(['case_',zz_setAllCaseName{i}]) = zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.timeSeriesData.continuousTimeData.cell;
                        end
                    end
                end
        end
    case 'off'
end
%% 結果の保存

switch zz_setExeOptim
    case 'on'
        switch zz_setType
            case 'All cases'
                if ~exist(fullfile('result','allCases'),'dir')
                    mkdir(fullfile('result','allCases')); % フォルダ作成
                end
                if isfield(zz_allCases,'summary')
                    if ~exist(fullfile('result','allCases','summary'),'dir')
                        mkdir(fullfile('result','allCases','summary')); % フォルダ作成
                    end
                    if ~exist(fullfile('result','allCases','summary','capAreaCostCo2'),'dir')
                        mkdir(fullfile('result','allCases','summary','capAreaCostCo2')); % フォルダ作成
                    end
                    writecell(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','capAreaCostCo2.csv'),'Encoding','Shift_JIS'); % 容量面積コストCO2セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','capAreaCostCo2.xlsx')); % 容量面積コストCO2セル配列保存(xlsx形式)
                    if ~exist(fullfile('result','allCases','summary','capAreaCostCo2','disassembly'),'dir')
                        mkdir(fullfile('result','allCases','summary','capAreaCostCo2','disassembly')); % フォルダ作成
                    end
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','caseSolInfo.csv'),'Encoding','Shift_JIS'); % ケース解情報セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','caseSolInfo.xlsx')); % ケース解情報セル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.cap.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','cap.csv'),'Encoding','Shift_JIS'); % 容量セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.cap.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','cap.xlsx')); % 容量セル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','areaEleCost.csv'),'Encoding','Shift_JIS'); % 面積電気料金セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','areaEleCost.xlsx')); % 面積電気料金セル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','gasWaterCost.csv'),'Encoding','Shift_JIS'); % ガス上下水道料金セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','gasWaterCost.xlsx')); % ガス上下水道料金セル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCost.csv'),'Encoding','Shift_JIS'); % 設備減価償却費セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCost.xlsx')); % 設備減価償却費セル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCost.csv'),'Encoding','Shift_JIS'); % 総コストセル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCost.xlsx')); % 総コストセル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCo2.csv'),'Encoding','Shift_JIS'); % 設備減価償却CO2排出量セル配列保存存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCo2.xlsx')); % 設備減価償却CO2排出量セル配列保存(xlsx形式)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCo2.csv'),'Encoding','Shift_JIS'); % 総CO2排出量セル配列保存(csv形式)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCo2.xlsx')); % 総CO2排出量セル配列保存(xlsx形式)

                    if ~exist(fullfile('result','allCases','summary','timeSeriesData'),'dir')
                        mkdir(fullfile('result','allCases','summary','timeSeriesData')); % フォルダ作成
                    end
                    if ~exist(fullfile('result','allCases','summary','timeSeriesData','discreteTimeData'),'dir')
                        mkdir(fullfile('result','allCases','summary','timeSeriesData','discreteTimeData')); % フォルダ作成
                    end
                    if ~exist(fullfile('result','allCases','summary','timeSeriesData','continuousTimeData'),'dir')
                        mkdir(fullfile('result','allCases','summary','timeSeriesData','continuousTimeData')); % フォルダ作成
                    end
                    for i = 1:length(zz_setAllCaseName)
                        if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                            writecell(zz_allCases.summary.timeSeriesData.discreteTimeData.cell.(['case_',zz_setAllCaseName{i}]),fullfile('result','allCases','summary','timeSeriesData','discreteTimeData',['case_',zz_setAllCaseName{i},'.csv']),'Encoding','Shift_JIS'); % 時系列データセル配列保存(csv形式)
                            writetable(cell2table(zz_allCases.summary.timeSeriesData.discreteTimeData.cell.(['case_',zz_setAllCaseName{i}])),fullfile('result','allCases','summary','timeSeriesData','discreteTimeData','discreteTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % 時系列データセル配列保存(xlsx形式)
                            writecell(zz_allCases.summary.timeSeriesData.continuousTimeData.cell.(['case_',zz_setAllCaseName{i}]),fullfile('result','allCases','summary','timeSeriesData','continuousTimeData',['case_',zz_setAllCaseName{i},'.csv']),'Encoding','Shift_JIS'); % 時系列データセル配列保存(csv形式)
                            writetable(cell2table(zz_allCases.summary.timeSeriesData.continuousTimeData.cell.(['case_',zz_setAllCaseName{i}])),fullfile('result','allCases','summary','timeSeriesData','continuousTimeData','continuousTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % 時系列データセル配列保存(xlsx形式)
                        else
                            writetable(table(),fullfile('result','allCases','summary','timeSeriesData','discreteTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % 時系列データセル配列保存(xlsx形式)
                            writetable(table(),fullfile('result','allCases','summary','timeSeriesData','continuousTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % 時系列データセル配列保存(xlsx形式)
                        end
                    end
                end
            case 'One case'
        end
    case 'off'
        switch zz_setType
            case 'All cases'
                load('result\allCases\workspace.mat')
            case 'One case'
                load(['result\case_',zz_setCaseName,'\workspace.mat'])
        end
end
%% 時系列データの図と成績係数に関する相関関係分析用散布図の作成と保存

switch zz_setFigureMake
    case 'on'
        switch zz_setType
            case 'All cases'
                for i = 1:length(zz_setAllCaseName)
                    zz_setCaseName = zz_setAllCaseName{i};
                    if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                        zz_parameter = zz_allCases.(['case_',zz_setCaseName]).zz_parameter;
                        zz_result = zz_allCases.(['case_',zz_setCaseName]).zz_result;
                        zz_table = zz_allCases.summary.timeSeriesData.continuousTimeData.timetable.(['case_',zz_setCaseName]);
                        switch zz_setMakeEachTimeSeriesData
                            case  'on'
                                outputer_figure_each_time_series_data(zz_setCaseName,zz_table,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay);
                        end
                        switch zz_setMakeEachTimeSeriesDataConfiguration
                            case  'on'
                                outputer_figure_each_time_series_data_configuration(zz_setCaseName,zz_parameter,zz_result,zz_table,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay,zz_setYLim);
                        end
                        switch zz_setMakeCorrelationAnalysisCOP
                            case  'on'
                                outputer_figure_correlation_analysis_COP_Each_Case(zz_setCaseName,zz_parameter,zz_table,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay);
                        end
                        switch zz_setMakeMIPGapConvergenceHistory
                            case  'on'
                                outputer_figure_MIPGap_convergence_history_Each_Case(zz_setCaseName,zz_result,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay,zz_setYLim);
                        end
                    end
                    clear zz_parameter;
                    clear zz_result;
                end
                zz_setAllFigStyle = {'paper','presentation','display'};
                if strcmp(zz_setMakeEachTimeSeriesData,'on') || strcmp(zz_setMakeEachTimeSeriesDataConfiguration,'on')
                    for j = 1:length(zz_setAllFigStyle)
                        for i = 1:length(zz_setAllCaseName)
                            if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                                if ~exist(fullfile('result','allCases','summary','figure'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig',zz_setAllFigStyle{j})); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf',zz_setAllFigStyle{j})); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf')); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig',zz_setAllFigStyle{j})); % フォルダ作成
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf',zz_setAllFigStyle{j})); % フォルダ作成
                                end
                                switch zz_setMakeEachTimeSeriesData
                                    case  'on'
                                        copyfile(fullfile('result',['case_',zz_setAllCaseName{i}],'summary','figure','eachTimeSeriesData','fig',zz_setAllFigStyle{j},'*'),fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig',zz_setAllFigStyle{j}));
                                        copyfile(fullfile('result',['case_',zz_setAllCaseName{i}],'summary','figure','eachTimeSeriesData','emf',zz_setAllFigStyle{j},'*'),fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf',zz_setAllFigStyle{j}));
                                end
                                switch zz_setMakeEachTimeSeriesDataConfiguration
                                    case  'on'
                                        copyfile(fullfile('result',['case_',zz_setAllCaseName{i}],'summary','figure','eachProfileConfiguration','fig',zz_setAllFigStyle{j},'*'),fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig',zz_setAllFigStyle{j}));
                                        copyfile(fullfile('result',['case_',zz_setAllCaseName{i}],'summary','figure','eachProfileConfiguration','emf',zz_setAllFigStyle{j},'*'),fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf',zz_setAllFigStyle{j}));
                                end
                            end
                        end
                    end
                end
                switch zz_setMakeCorrelationAnalysisCOP
                    case  'on'
                        if isfield(zz_allCases,'summary')
                            outputer_figure_correlation_analysis_COP_All_Case(zz_setAllCaseName,zz_allCases,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay,zz_setYLim);
                        end
                end
                switch zz_setMakeMIPGapConvergenceHistory
                    case  'on'
                        if isfield(zz_allCases,'summary')
                            outputer_figure_MIPGap_convergence_history_All_Case(zz_setAllCaseName,zz_allCases,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay,zz_setYLim);
                        end
                end
            case 'One case'
                if isempty(zz_result.fval) == 0 %[-] zz_fvalが空でない場合(解がある場合)
                    zz_table = zz_result.summary.timeSeriesData.continuousTimeData.timetable;
                    switch zz_setMakeEachTimeSeriesData
                        case  'on'
                            outputer_figure_each_time_series_data(zz_setCaseName,zz_table,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay);
                    end
                    switch zz_setMakeEachTimeSeriesDataConfiguration
                        case  'on'
                            outputer_figure_each_time_series_data_configuration(zz_setCaseName,zz_parameter,zz_result,zz_table,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay,zz_setYLim);
                    end
                    switch zz_setMakeCorrelationAnalysisCOP
                        case  'on'
                            outputer_figure_correlation_analysis_COP_Each_Case(zz_setCaseName,zz_parameter,zz_table,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay);
                    end
                    switch zz_setMakeMIPGapConvergenceHistory
                        case  'on'
                            outputer_figure_MIPGap_convergence_history_Each_Case(zz_setCaseName,zz_result,zz_setTitleDisplay,zz_setTitleCaseDisplay,zz_setLegendDisplay,zz_setXAxisSecondaryLabelDisplay,zz_setYLim);
                    end
                end
        end
    case 'off'
end

clear zz_setCaseName;
clear zz_table;
clear zz_setFigureMake;
clear zz_setMakeEachTimeSeriesData;
clear zz_setMakeEachTimeSeriesDataConfiguration;
clear zz_setMakeCorrelationAnalysisCOP;
clear zz_setMakeMIPGapConvergenceHistory;
clear zz_setTitleDisplay;
clear zz_setTitleCaseDisplay;
clear zz_setLegendDisplay;
clear zz_setXAxisSecondaryLabelDisplay;
clear zz_setYLim;

clear zz_setAllCaseName;
clear zz_setAllFigStyle;
clear i;
clear j;
%% フッター(結果の保存)

switch zz_setType
    case 'All cases'
        clear zz_setType;
        zz_executeTime.script = toc(zz_scriptStartTime); % スクリプト実行時間測定終了[-]
        clear zz_scriptStartTime
        switch zz_setExeOptim
            case 'on'
                clear zz_setExeOptim;
                save(fullfile('result','allCases','workspace.mat'),"zz_allCases","zz_executeTime"); % ワークスペース内容保存
            case 'off'
                clear zz_setExeOptim;
                clear zz_setDisplay
                clear zz_setEnergyAmountRateUnitPrice
                clear zz_setCO2emissionFactor;
                clear zz_setMaxTime
                clear zz_setSolver
                clear zz_setSolverVer;
        end
        disp(['Finish executing script at ',char(datetime('now'))]);
        disp(['Execution time for script is ',num2str(zz_executeTime.script),' seconds']);
        disp('Execution time summary: (unit is second)');
        disp(zz_executeTime);
        if ~isfield(zz_allCases,'summary')
            disp('No solution was found in all cases.');
        end
    case 'One case'
        clear zz_setType;
        clear zz_setExeOptim;
        clear zz_setDisplay
        clear zz_setEnergyAmountRateUnitPrice
        clear zz_setCO2emissionFactor;
        clear zz_setMaxTime
        clear zz_setSolver
        clear zz_setSolverVer;
        zz_executeTime.script = toc(zz_scriptStartTime); % スクリプト実行時間測定終了[-]
        clear zz_scriptStartTime
        disp(['Finish executing script at ',char(datetime('now'))]);
        disp(['Execution time for script is ',num2str(zz_executeTime.script),' seconds']);
        disp('Execution time summary: (unit is second)');
        disp(zz_executeTime);
end