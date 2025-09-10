%% ���v���G�l���M�[�V�X�e���̋Z�p�I���E�ݔ��e�ʌv��E�^�]�v��̓����œK���̎��s��
% *Executor of Optimal Joint Planning of Technology Selection, Capacities Planning, 
% and Operation Scheduling for Demand-Side Energy System*
%% *�����*
%% 
% * MATLAB R2024b
% * Optimization Toolbox
% * Parallel Computing Toolbox
% * (Gurobi Optimizer V. 12.0)
%% �w�b�_�[

close all; % �}��S�ĕ���

zz_setNotify = 'on'; % [-]
switch zz_setNotify
    case 'on'
        clearvars -except fileName token url options % ���[�N�X�y�[�X����ϐ���fileName�Ctoken�Curl�Coptions�������ăA�C�e�����폜
        % LINE�ʒm���s���ۂ́Czz_setNotify��on�ɂ�����C���̃t�@�C����executor_OJP_TSCPOS_DES�ŕۑ������̂��C���L�̃R�}���h���R�}���h�E�B���h�E�Ŏ��s
        % executor_simulation_exit_notification('executor_OJP_TSCPOS_DES')
    case 'off'
        clear; % ���[�N�X�y�[�X����A�C�e�����폜
        % LINE�ʒm���s��Ȃ��ۂ́Czz_setNotify��off�ɂ�����C���L�̃R�}���h���R�}���h�E�B���h�E�Ŏ��s
        % executor_OJP_TSCPOS_DES
        % (�R�}���h�E�B���h�E�Ŏ��s���Ȃ��ꍇ�Cmlx�̏o�̓E�B���h�E�Ƀ��O������ʂɕ\������C�t���[�Y����\�������邽�߁C�R�}���h�E�B���h�E����̎��s�𐄏�)
end

disp(['Start executing script at ',char(datetime('now'))]);
zz_scriptStartTime = tic; % �X�N���v�g���s���ԑ���J�n[-]
%% ���s�̐ݒ�

zz_setType = 'All cases'; % [-]
switch zz_setType
    case 'One case'
        zz_setCaseName = '1ax'; % [-]
end
zz_setEnergyAmountRateUnitPrice = 'static'; % [-] % �����d�����P��(�d�͗ʗ����P���Ɣ��旿���P��)�̐ݒ�
zz_setCO2emissionFactor = 'static'; % [-] % CO2�r�o�W���̐ݒ�
zz_setMaxTime = 18000; % [second] % 10���ȏ㐄��(�����ԃV�~�����[�V����������ƃ������G���[�ɂȂ邱�Ƃ����邽�ߒ���)
zz_setDisplay = 'iter'; % [-] % iter����(�œK���̃��O���R�}���h�E�B���h�E�ɕ\������ۂɂ�iter)
zz_setSolver = 'Gurobi'; % [-] % Gurobi����
switch zz_setSolver
    case 'Gurobi'
        zz_setSolverVer = '12.0.2'; % [-] % 12.0.2����
    case 'MATLAB'
        zz_setSolverVer = 'R2024b'; % [-] % R2024b����
end
zz_setExeOptim = 'on'; % [-] % off�Ŏ��s����ꍇ��result�������Ă���ꍇ�̂ݎ��s�\
zz_setFigureMake = 'on'; % [-] % All cases�̂��ׂĂ̐}�쐬�ɂ͂��Ȃ莞�Ԃ�������
switch zz_setFigureMake
    case 'on'
        zz_setMakeEachTimeSeriesData = 'on'; % [-] % �e���n��f�[�^�̐}�쐬�̗L���̐ݒ�
        zz_setMakeEachTimeSeriesDataConfiguration = 'on'; % [-] % �e���n��f�[�^�̎�v�ȍ\���̐}�쐬�̗L���̐ݒ�
        zz_setMakeCorrelationAnalysisCOP = 'on'; % [-] % ���ьW���Ɋւ��鑊�֊֌W���͗p�̐}�쐬�̗L���̐ݒ�
        zz_setMakeMIPGapConvergenceHistory = 'on'; % [-] % MIPGap�̎��������̐}�쐬�̗L���̐ݒ�

        zz_setTitleDisplay = 'off'; % [-] % off����(�}�̕ۑ��X�^�C��(zz_figStyle)��'paper'�܂���'presentation'�̂Ƃ��ɐݒ肪�L��('display'�̂Ƃ��͐ݒ�Ɋ֌W�Ȃ������I�Ƀ^�C�g�����t��))
        zz_setTitleCaseDisplay = 'on'; % [-] % on����(�}�̕ۑ��X�^�C��(zz_figStyle)��'paper'�܂���'presentation'�̂Ƃ��ɐݒ肪�L��('display'�̂Ƃ��͐ݒ�Ɋ֌W�Ȃ������I�ɃP�[�X���t��))
        zz_setLegendDisplay = 'off'; % [-] % off����(�}�̕ۑ��X�^�C��(zz_figStyle)��'paper'�܂���'presentation'�̂Ƃ��ɐݒ肪�L��('display'�̂Ƃ��͐ݒ�Ɋ֌W�Ȃ������I�ɖ}�Ⴊ�t��))
        zz_setXAxisSecondaryLabelDisplay = 'off'; % [-] % off����(on�̏ꍇ�C�O���t�̉E���ɓ��t��\��)
        zz_setYLim = 'fixed for paper condition'; % [-] % 'fixed for paper condition'����(�p�����[�^��O���\���l��ς���ꍇ��auto����)
end
%% �P�[�X���͊�̎��s

switch zz_setExeOptim
    case 'on'
        switch zz_setType
            case 'All cases'
                zz_setAllCaseName = {'1ax','1ay','1bx','1by','2ax','2ay','2bx','2by'};
                disp(['Start executing parfor at ',char(datetime('now'))]);
                zz_parforStartTime = tic; % parfor���s���ԑ���J�n[-]
                zz_tempTime = cell(length(zz_setAllCaseName),1);
                parfor i = 1:length(zz_setAllCaseName)
                    zz_setCaseName = zz_setAllCaseName{i}; %#ok<PFTUSW>

                    disp(['Start executing Case ',zz_setCaseName]);
                    zz_caseAnalysisStartTime = tic; % Case���͎��s���ԑ���J�n[-]

                    analyzer_case_OJP_TSCPOS_DES(zz_setCaseName,zz_setEnergyAmountRateUnitPrice,zz_setCO2emissionFactor,zz_setMaxTime,zz_setDisplay,zz_setSolver,zz_setSolverVer);

                    zz_tempTime{i} = toc(zz_caseAnalysisStartTime); % Case���͎��s���ԑ���I��[-]
                    disp(['Finish executing Case ',zz_setCaseName]);
                end
                for i = 1:length(zz_setAllCaseName)
                    zz_setCaseName = zz_setAllCaseName{i};
                    zz_executeTime.(['case_',zz_setCaseName]) = zz_tempTime{i};
                end
                zz_executeTime.parfor = toc(zz_parforStartTime); % parfor���s���ԑ���I��[-]
                disp(['Finish executing parfor at ',char(datetime('now'))]);
                disp(['Execution time for parfor is ',num2str(zz_executeTime.parfor),' seconds']);

            case 'One case'
                disp(['Start executing Case ',zz_setCaseName]);
                zz_caseAnalysisStartTime = tic; % Case���͎��s���ԑ���J�n[-]
%%
                [zz_case,zz_parameter,zz_disturbance,zz_prob,zz_result] = analyzer_case_OJP_TSCPOS_DES(zz_setCaseName,zz_setEnergyAmountRateUnitPrice,zz_setCO2emissionFactor,zz_setMaxTime,zz_setDisplay,zz_setSolver,zz_setSolverVer); % ���̍s�̓X�N���v�g�ɂ����ĕ\���̂��߂ɂ����ăZ�N�V�����𕪊�
%%
                zz_executeTime.(['case_',zz_setCaseName]) = toc(zz_caseAnalysisStartTime); % Case���͎��s���ԑ���I��[-]
                disp(['Finish executing Case ',zz_setCaseName]);
                disp(['Execution time for Case ',zz_setCaseName,' is ',num2str(zz_executeTime.(['case_',zz_setCaseName])),' seconds']);
        end
    case 'off'
        switch zz_setType
            case 'All cases'
                zz_setAllCaseName = {'1ax','1ay','1bx','1by','2ax','2ay','2bx','2by'};
        end
end
%% ���ʂ̐���

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
                    if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
                        zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct = zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.summary.capAreaCostCo2.capAreaCostCo2.struct;
                        zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct = rmfield(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct,'value');
                        break
                    end
                end
                for i = 1:length(zz_setAllCaseName)
                    if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
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
                    zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct))'; % �e�ʖʐσR�X�gCO2�Z���z��(�e�ʂƖʐς͏������ʈȉ��؂�グ�C�R�X�g�͏����_�ȉ��؂�̂āCCO2�r�o�ʂ͏�����O�ʈȉ��؂�̂�)[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct(1:10); % �P�[�X�����\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.struct))'; % �P�[�X�����Z���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.cap.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,11:27]); % �e�ʍ\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.cap.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.cap.struct))'; % �e�ʃZ���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,28:37]); % �ʐϓd�C�����\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.struct))'; % �ʐϓd�C�����Z���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,38:47]); % �K�X�㉺���������\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.struct))'; % �K�X�㉺���������Z���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,49:66]); % �ݔ��������p��\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.struct))'; % �ݔ��������p��Z���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,37,42,47,48,66,67]); % ���R�X�g�\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.struct))'; % ���R�X�g�Z���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,76:93]); % �ݔ��������pCO2�r�o�ʍ\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.struct))'; % �ݔ��������pCO2�r�o�ʃZ���z��[any]

                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.struct = zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.struct([1,68:75,93,94]); % ��CO2�r�o�ʍ\����[any]
                    zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.cell = table2cell(struct2table(zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.struct))'; % ��CO2�r�o�ʃZ���z��[any]

                    for i = 1:length(zz_setAllCaseName)
                        if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
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
%% ���ʂ̕ۑ�

switch zz_setExeOptim
    case 'on'
        switch zz_setType
            case 'All cases'
                if ~exist(fullfile('result','allCases'),'dir')
                    mkdir(fullfile('result','allCases')); % �t�H���_�쐬
                end
                if isfield(zz_allCases,'summary')
                    if ~exist(fullfile('result','allCases','summary'),'dir')
                        mkdir(fullfile('result','allCases','summary')); % �t�H���_�쐬
                    end
                    if ~exist(fullfile('result','allCases','summary','capAreaCostCo2'),'dir')
                        mkdir(fullfile('result','allCases','summary','capAreaCostCo2')); % �t�H���_�쐬
                    end
                    writecell(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','capAreaCostCo2.csv'),'Encoding','Shift_JIS'); % �e�ʖʐσR�X�gCO2�Z���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.capAreaCostCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','capAreaCostCo2.xlsx')); % �e�ʖʐσR�X�gCO2�Z���z��ۑ�(xlsx�`��)
                    if ~exist(fullfile('result','allCases','summary','capAreaCostCo2','disassembly'),'dir')
                        mkdir(fullfile('result','allCases','summary','capAreaCostCo2','disassembly')); % �t�H���_�쐬
                    end
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','caseSolInfo.csv'),'Encoding','Shift_JIS'); % �P�[�X�����Z���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.caseSolInfo.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','caseSolInfo.xlsx')); % �P�[�X�����Z���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.cap.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','cap.csv'),'Encoding','Shift_JIS'); % �e�ʃZ���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.cap.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','cap.xlsx')); % �e�ʃZ���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','areaEleCost.csv'),'Encoding','Shift_JIS'); % �ʐϓd�C�����Z���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.areaEleCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','areaEleCost.xlsx')); % �ʐϓd�C�����Z���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','gasWaterCost.csv'),'Encoding','Shift_JIS'); % �K�X�㉺���������Z���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.gasWaterCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','gasWaterCost.xlsx')); % �K�X�㉺���������Z���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCost.csv'),'Encoding','Shift_JIS'); % �ݔ��������p��Z���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCost.xlsx')); % �ݔ��������p��Z���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCost.csv'),'Encoding','Shift_JIS'); % ���R�X�g�Z���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCost.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCost.xlsx')); % ���R�X�g�Z���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCo2.csv'),'Encoding','Shift_JIS'); % �ݔ��������pCO2�r�o�ʃZ���z��ۑ���(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.equipCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','equipCo2.xlsx')); % �ݔ��������pCO2�r�o�ʃZ���z��ۑ�(xlsx�`��)

                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCo2.csv'),'Encoding','Shift_JIS'); % ��CO2�r�o�ʃZ���z��ۑ�(csv�`��)
                    writecell(zz_allCases.summary.capAreaCostCo2.disassembly.totalCo2.cell,fullfile('result','allCases','summary','capAreaCostCo2','disassembly','totalCo2.xlsx')); % ��CO2�r�o�ʃZ���z��ۑ�(xlsx�`��)

                    if ~exist(fullfile('result','allCases','summary','timeSeriesData'),'dir')
                        mkdir(fullfile('result','allCases','summary','timeSeriesData')); % �t�H���_�쐬
                    end
                    if ~exist(fullfile('result','allCases','summary','timeSeriesData','discreteTimeData'),'dir')
                        mkdir(fullfile('result','allCases','summary','timeSeriesData','discreteTimeData')); % �t�H���_�쐬
                    end
                    if ~exist(fullfile('result','allCases','summary','timeSeriesData','continuousTimeData'),'dir')
                        mkdir(fullfile('result','allCases','summary','timeSeriesData','continuousTimeData')); % �t�H���_�쐬
                    end
                    for i = 1:length(zz_setAllCaseName)
                        if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
                            writecell(zz_allCases.summary.timeSeriesData.discreteTimeData.cell.(['case_',zz_setAllCaseName{i}]),fullfile('result','allCases','summary','timeSeriesData','discreteTimeData',['case_',zz_setAllCaseName{i},'.csv']),'Encoding','Shift_JIS'); % ���n��f�[�^�Z���z��ۑ�(csv�`��)
                            writetable(cell2table(zz_allCases.summary.timeSeriesData.discreteTimeData.cell.(['case_',zz_setAllCaseName{i}])),fullfile('result','allCases','summary','timeSeriesData','discreteTimeData','discreteTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % ���n��f�[�^�Z���z��ۑ�(xlsx�`��)
                            writecell(zz_allCases.summary.timeSeriesData.continuousTimeData.cell.(['case_',zz_setAllCaseName{i}]),fullfile('result','allCases','summary','timeSeriesData','continuousTimeData',['case_',zz_setAllCaseName{i},'.csv']),'Encoding','Shift_JIS'); % ���n��f�[�^�Z���z��ۑ�(csv�`��)
                            writetable(cell2table(zz_allCases.summary.timeSeriesData.continuousTimeData.cell.(['case_',zz_setAllCaseName{i}])),fullfile('result','allCases','summary','timeSeriesData','continuousTimeData','continuousTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % ���n��f�[�^�Z���z��ۑ�(xlsx�`��)
                        else
                            writetable(table(),fullfile('result','allCases','summary','timeSeriesData','discreteTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % ���n��f�[�^�Z���z��ۑ�(xlsx�`��)
                            writetable(table(),fullfile('result','allCases','summary','timeSeriesData','continuousTimeData.xlsx'),'Sheet',['case_',zz_setAllCaseName{i}]); % ���n��f�[�^�Z���z��ۑ�(xlsx�`��)
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
%% ���n��f�[�^�̐}�Ɛ��ьW���Ɋւ��鑊�֊֌W���͗p�U�z�}�̍쐬�ƕۑ�

switch zz_setFigureMake
    case 'on'
        switch zz_setType
            case 'All cases'
                for i = 1:length(zz_setAllCaseName)
                    zz_setCaseName = zz_setAllCaseName{i};
                    if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
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
                            if isempty(zz_allCases.(['case_',zz_setAllCaseName{i}]).zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
                                if ~exist(fullfile('result','allCases','summary','figure'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','fig',zz_setAllFigStyle{j})); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachTimeSeriesData','emf',zz_setAllFigStyle{j})); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf'),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf')); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','fig',zz_setAllFigStyle{j})); % �t�H���_�쐬
                                end
                                if ~exist(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf',zz_setAllFigStyle{j}),'dir')
                                    mkdir(fullfile('result','allCases','summary','figure','eachProfileConfiguration','emf',zz_setAllFigStyle{j})); % �t�H���_�쐬
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
                if isempty(zz_result.fval) == 0 %[-] zz_fval����łȂ��ꍇ(��������ꍇ)
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
%% �t�b�^�[(���ʂ̕ۑ�)

switch zz_setType
    case 'All cases'
        clear zz_setType;
        zz_executeTime.script = toc(zz_scriptStartTime); % �X�N���v�g���s���ԑ���I��[-]
        clear zz_scriptStartTime
        switch zz_setExeOptim
            case 'on'
                clear zz_setExeOptim;
                save(fullfile('result','allCases','workspace.mat'),"zz_allCases","zz_executeTime"); % ���[�N�X�y�[�X���e�ۑ�
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
        zz_executeTime.script = toc(zz_scriptStartTime); % �X�N���v�g���s���ԑ���I��[-]
        clear zz_scriptStartTime
        disp(['Finish executing script at ',char(datetime('now'))]);
        disp(['Execution time for script is ',num2str(zz_executeTime.script),' seconds']);
        disp('Execution time summary: (unit is second)');
        disp(zz_executeTime);
end