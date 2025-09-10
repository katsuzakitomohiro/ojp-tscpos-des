# OJP-TSCPOS-DES

**Optimal Joint Planning of Technology Selection, Capacities Planning, and Operation Scheduling for Demand-Side Energy System**

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15790318.svg)](https://doi.org/10.5281/zenodo.15790318)

## 概要

本リポジトリは、研究論文「ヒートポンプ給湯機のダイナミクスと電気・熱・水の連携を考慮した需要側エネルギーシステムの技術選択・設備容量計画・運転計画の同時最適化」に関連するソースコードとデータを保管するものです。

## 論文情報

- **掲載誌**: 
  - [エネルギー・資源](https://www.jser.gr.jp/mj/magazine/) 9月号（通巻273号）
  - [エネルギー・資源学会論文誌](https://www.jstage.jst.go.jp/browse/jjser/-char/ja) 46巻5号
- **刊行日**: 2025年9月10日
- **論文題目**: ヒートポンプ給湯機のダイナミクスと電気・熱・水の連携を考慮した需要側エネルギーシステムの技術選択・設備容量計画・運転計画の同時最適化
- **DOI**: [10.24778/jjser.46.5_XXX](https://doi.org/10.24778/jjser.46.5_XXX)

## 動作環境

### 必要なソフトウェア
- **MATLAB R2024b** （強く推奨）
- **Optimization Toolbox** （必須）
- **Gurobi Optimizer V. 12.0** （推奨・オプション）
  - 大学関係者は2025年9月現在、アカデミックライセンスにより無料で使用可能です

### オプションソフトウェア
- **Parallel Computing Toolbox**: 無くても並列計算は可能ですが、より高度な並列処理機能を利用できます

### 動作確認環境
- **CPU**: Intel Core i9-13900 (最大5.2GHz、8P+16Eコア、32スレッド)
- **RAM**: 32GB (DDR5)
- **OS**: Windows 11 Pro 64-bit
- **GPU**: NVIDIA GeForce RTX 4070

### 重要事項
- **出力ファイルサイズ**: 図の作成を含めると約10GBに達します
- **実行時間**: 
  - 図の出力のみで数十分程度かかります
  - 最適化時間制限を300分に設定した場合、全体で約6時間程度を要します
- **Gurobiパス**: Gurobi等のインストールpathはデフォルト設定を想定しています

### MATLAB バージョンについて
- **本プロジェクトのファイル形式**: 現在は`.mlx`ファイル（Live Scriptのバイナリ形式）で開発されています
- **AIサービスとの相性**: `.mlx`ファイルはバイナリ形式のため、現在急速に発展するAIサービス（ChatGPT、Claude等）でのコード解析が困難です
- **解決策**: **MATLAB R2025a**では、`.mlx`ファイルを`.m`形式（非バイナリ形式）に変換する機能が追加されました。これにより、AIサービスを利用したプログラム全体の解析や改良も可能となります
- **実行時の注意**: 本プログラムをMATLAB R2025aで実行する場合、グラフ作成時にエラーが発生することがあります。**MATLAB R2024bでの実行を強く推奨**します
- 実行環境やGurobi OptimizerのバージョンによってはログファイルからMIPGap収束過程を可視化するファイルがうまく動作しない可能性があります

## プログラム構造とファイル構成

### メインファイル
- **`executor_OJP_TSCPOS_DES.mlx`**: メイン実行ファイル

### 主要な設定ファイル
- **`setter_formula_JOP_TSCPOS_DES.mlx`**: 最適化問題の定式化（for文を使用しない高速化実装）。詳細な定式化は[プレプリント論文1](https://doi.org/10.51094/jxiv.1066)を参照
- **`setter_disturbance_predicted_value_JOP_TSCPOS_DES.mlx`**: 外乱予測値設定
- **`setter_parameter_JOP_TSCPOS_DES.mlx`**: システムパラメータ設定

## 使用方法

### 事前準備

1. **MATLAB環境設定**:
   - MATLABを起動し、プロジェクトフォルダを作業ディレクトリに設定
   - Optimization Toolboxがインストールされていることを確認
   - Gurobi使用時は、MATLABからGurobiにアクセスできることを確認

### 初回実行手順

1. **MATLABでプロジェクトを開く**:
   ```matlab
   cd('C:\path\to\ojp-tscpos-des')  % プロジェクトフォルダのパスを指定
   ```

2. **簡単な動作確認**:
   ```matlab
   % 設定確認（エラーが出ないことを確認）
   which('intlinprog')  % Optimization Toolboxの確認
   ```

3. **テスト実行（推奨）**:
   - 初回は短時間で終わる設定で実行することを強く推奨
   - `executor_OJP_TSCPOS_DES.m`を開き、以下を変更：
     ```matlab
     zz_setType = 'One case';          % 全ケースではなく1ケースのみ
     zz_setCaseName = '1ax';           % 最もシンプルなケース  
     zz_setMaxTime = 60;               % 1分制限（テスト用）
     zz_setFigureMake = 'off';         % 図作成を無効化（高速化）
     ```

4. **テスト実行**:
   ```matlab
   executor_OJP_TSCPOS_DES
   ```

### 本格実行手順

1. **ケース設定**: `executor_OJP_TSCPOS_DES.m`のヘッダー部分で設定を変更
   - 各ケース名は論文の表1に対応しています
   - **デフォルト設定**: エネルギー・資源学会論文の設定になっています
   - `zz_setCO2emissionFactor`を`'dynamic'`に変更することで、[プレプリント論文2](https://doi.org/10.51094/jxiv.1197)と同じ設定でシミュレーション可能です

2. **実行**: MATLABのコマンドプロンプトで以下を実行
   ```matlab
   executor_OJP_TSCPOS_DES
   ```

### ⚠️ 実行時の注意事項
- **コマンドプロンプトからの実行を推奨**: MATLABエディタ上部の実行ボタンから実行する場合、スクリプトの右側コラムに結果が表示されますが、出力が多すぎるためフリーズする可能性があります

### 推奨設定
- **最適化時間制限**: `zz_setMaxTime = 300`分を推奨
- **総実行時間**: 画像の可視化も含めると、全ケースを並列して実行する場合、約6時間を要します
- **ソルバー**: MATLABのOptimization ToolboxのソルバーでもGurobiでも実行可能ですが、**Gurobiを推奨**します

### 出力ファイル
実行結果は`result/`フォルダに自動的に出力されます：
- **個別ケース結果**: `result/case_*/` （case_1ax, case_1ay, ..., case_2byの8つのフォルダ）
- **統合結果**: `result/allCases/`
- **データファイル**: CSV、XLSX、MAT形式で保存
- **図表ファイル**: FIG、EMF形式で保存（論文用、発表用、表示用の3つのスタイル）

## LINE通知機能（オプション）

シミュレーションの実行終了時にLINE通知を送信する機能を提供しています。

### 設定手順

1. **トークン設定**: `token/token.mat`ファイルにLINE Messaging APIのチャネルアクセストークンを設定
   - 参考記事:
     - https://qiita.com/jksoft/items/4d57a9282a56c38d0a9c
     - https://qiita.com/MikH/items/d9876b6e50f7c8510d0b

2. **通知機能有効化**: 
   ```matlab
   zz_setNotify = 'on'; % [-]
   ```
   に設定して`executor_OJP_TSCPOS_DES`を上書き保存

3. **実行**: コマンドプロンプトで以下を実行
   ```matlab
   executor_simulation_exit_notification('executor_OJP_TSCPOS_DES')
   ```

## プログラムの入出力関係

```
executor_OJP_TSCPOS_DES.mlx (メイン実行器)
│
├─ 並列実行 → analyzer_case_OJP_TSCPOS_DES.mlx (各ケース分析器)
│              │
│              ├─ 入力: ケース名, 設定パラメータ
│              │
│              ├─ 呼び出し → setter_case_information_OJP_TSCPOS_DES.mlx
│              │              └─ 出力: zz_case (ケース情報)
│              │
│              ├─ 呼び出し → setter_parameter_JOP_TSCPOS_DES.mlx
│              │              ├─ 入力: zz_case
│              │              └─ 出力: zz_parameter (システムパラメータ)
│              │
│              ├─ 呼び出し → setter_disturbance_predicted_value_JOP_TSCPOS_DES.mlx
│              │              ├─ 入力: zz_parameter
│              │              ├─ データ読み込み: data/ (気象・負荷データ)
│              │              ├─ 呼び出し → creator_dynamic_energy_amount_rate_unit_price.mlx
│              │              │              └─ データ読み込み: data/spot_summary_2023.csv
│              │              ├─ 呼び出し → estimator_dynamic_CO2_emission_factor_for_electric_utility.mlx
│              │              └─ 出力: zz_disturbance (外乱予測値)
│              │
│              ├─ 呼び出し → setter_formula_JOP_TSCPOS_DES.mlx
│              │              ├─ 入力: zz_case, zz_parameter, zz_disturbance
│              │              └─ 出力: zz_prob (最適化問題)
│              │
│              ├─ 最適化実行 → api/case_*/intlinprog.mlx (Gurobiソルバー設定)
│              │              └─ 出力: zz_result.sol, zz_result.fval
│              │
│              ├─ 収束履歴作成 → creator_Gurobi_MIPGap_convergence_history.mlx
│              │                 └─ 出力: zz_result.mipGapHistory
│              │
│              └─ 出力: result/case_*/workspace.mat
│
├─ 結果統合・分析
│  ├─ 呼び出し → calculator_result_analysis_median_COP.mlx
│  │              ├─ 入力: zz_allCases
│  │              └─ 出力: COP中央値分析結果
│  │
│  ├─ 呼び出し → calculator_result_analysis_total_output_thermal_energy_HPU.mlx
│  │              ├─ 入力: zz_allCases
│  │              └─ 出力: HPU総出力熱量分析結果
│  │
│  └─ 出力: result/allCases/workspace.mat, CSV/XLSX形式の各種データ
│
└─ 図表生成
   ├─ 呼び出し → outputer_figure_each_time_series_data.mlx
   │              ├─ 入力: ケース名, zz_table, 表示設定
   │              ├─ 呼び出し → setter_common_property_output_figure.mlx (図の共通設定)
   │              └─ 出力: result/case_*/summary/figure/eachTimeSeriesData/
   │
   ├─ 呼び出し → outputer_figure_each_time_series_data_configuration.mlx
   │              └─ 出力: result/case_*/summary/figure/eachProfileConfiguration/
   │
   ├─ 呼び出し → outputer_figure_correlation_analysis_COP_Each_Case.mlx
   │              └─ 出力: result/case_*/summary/figure/correlationAnalysisCOP/
   │
   ├─ 呼び出し → outputer_figure_correlation_analysis_COP_All_Case.mlx
   │              └─ 出力: result/allCases/summary/figure/correlationAnalysisCOP/
   │
   ├─ 呼び出し → outputer_figure_MIPGap_convergence_history_Each_Case.mlx
   │              └─ 出力: result/case_*/summary/figure/mipGapConvergenceHistory/
   │
   └─ 呼び出し → outputer_figure_MIPGap_convergence_history_All_Case.mlx
                  └─ 出力: result/allCases/summary/figure/mipGapConvergenceHistory/

LINE通知機能:
executor_OJP_TSCPOS_DES_for_notify.m
└─ 呼び出し → executor_simulation_exit_notification.mlx
               ├─ 入力: 実行ファイル名
               ├─ 読み込み: token/ (LINE通知トークン)
               └─ 機能: 計算完了時のLINE通知送信
```

## ライセンス

本リポジトリの内容にはMITライセンスを付与しております。

## 連絡先

本研究や本リポジトリに関するお問い合わせは、論文の著者までご連絡ください。

---

*このリポジトリは研究の透明性と再現性を高めることを目的としています。*