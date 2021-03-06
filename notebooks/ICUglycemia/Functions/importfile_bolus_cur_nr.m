function BolusesCURnr1 = importfile_bolus_cur_nr(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  BOLUSESCURNR1 = IMPORTFILE(FILE) reads data from the first worksheet
%  in the Microsoft Excel spreadsheet file named FILE.  Returns the data
%  as a table.
%
%  BOLUSESCURNR1 = IMPORTFILE(FILE, SHEET) reads from the specified
%  worksheet.
%
%  BOLUSESCURNR1 = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  BolusesCURnr1 = importfile_bolus_cur_nr("BolusesCUR_nr.xlsx", "BolusesCUR_nr", [2, 88465]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 14-Apr-2020 19:06:57

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 88465];
end

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 22);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":V" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["SUBJECT_ID", "HADM_ID", "ICUSTAY_ID", "ICU_ADMISSIONTIME", "ICU_DISCHARGETIME", "Var6", "Var7", "Var8", "STARTTIME", "Var10", "Var11", "INPUT", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "GLC_AL", "GLCTIMER_AL", "GLCSOURCE_AL", "RULE"];
opts.SelectedVariableNames = ["SUBJECT_ID", "HADM_ID", "ICUSTAY_ID", "ICU_ADMISSIONTIME", "ICU_DISCHARGETIME", "STARTTIME", "INPUT", "GLC_AL", "GLCTIMER_AL", "GLCSOURCE_AL", "RULE"];
opts.VariableTypes = ["double", "double", "double", "datetime", "datetime", "char", "char", "char", "datetime", "char", "char", "double", "char", "char", "char", "char", "char", "char", "double", "datetime", "categorical", "double"];

% Specify variable properties
opts = setvaropts(opts, ["Var6", "Var7", "Var8", "Var10", "Var11", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var6", "Var7", "Var8", "Var10", "Var11", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "GLCSOURCE_AL"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "ICU_ADMISSIONTIME", "InputFormat", "");
opts = setvaropts(opts, "ICU_DISCHARGETIME", "InputFormat", "");
opts = setvaropts(opts, "STARTTIME", "InputFormat", "");
opts = setvaropts(opts, "GLCTIMER_AL", "InputFormat", "");

% Import the data
BolusesCURnr1 = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":V" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    BolusesCURnr1 = [BolusesCURnr1; tb]; %#ok<AGROW>
end

end