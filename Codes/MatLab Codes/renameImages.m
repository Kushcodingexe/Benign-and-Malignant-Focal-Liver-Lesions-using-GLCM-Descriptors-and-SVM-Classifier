% Define the folder path (update with your actual path)
folderPath = "C:\Users\jyoti\Downloads\Final_Datase_augment_balanced\FNH\Train\Augmented Rois";

% Get all image files
imageFiles = dir(fullfile(folderPath, '*.jpg'));  % Change '*.jpg' to your image format (e.g., '*.png', '*.bmp')

% Loop through each image file
for i = 1:length(imageFiles)
  % Extract the original filename and extension
  [~, originalFilename, ext] = fileparts(imageFiles(i).name);
  
  % Create a new filename with sequence number
  newFilename = sprintf('%d%s', i, ext);
  
  % Rename the file
  movefile(fullfile(folderPath, imageFiles(i).name), fullfile(folderPath, newFilename));
end

% Display message
disp('Images renamed successfully!');
