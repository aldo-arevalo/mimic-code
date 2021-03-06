function diabetes = importDiabetes(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  DIABETES = IMPORTFILE(FILE) reads data from the first worksheet in
%  the Microsoft Excel spreadsheet file named FILE.  Returns the data as
%  a table.
%
%  DIABETES = IMPORTFILE(FILE, SHEET) reads from the specified worksheet.
%
%  DIABETES = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
%  specified worksheet for the specified row interval(s). Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  diabetes = importDiabetes("/Documents/MATLAB/diabetes.xlsx", "DIABETES", [2, 61052]);
%

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 61052];
end

%% Setup the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 2);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":B" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["ICUSTAY_ID", "DIABETES"];
opts.VariableTypes = ["double", "double"];

% Import the data
diabetes = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":B" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    diabetes = [diabetes; tb]; %#ok<AGROW>
end

end
