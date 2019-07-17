%% writeS2T
%
% A simple write structure to tab-delimited script... also see writeM2T
%
% Fred Hasselman (me@fredhasselman.com) - November 2011

function writeS2T(structure,filename)
    
    if ~exist('structure','var')
        error('no structure')
    end;
    
    if ~exist('filename','var')
        error('no filename')
    end;
    
    [r c]  = size(structure);
    header = ['row';'col';fieldnames(structure)];

    fid = fopen(filename, 'w');
     
    %Write header with fieldnames
    for h=1:length(header)-1
        fprintf(fid, '%s\t ',header{h});
    end
    fprintf(fid, '%s\n',header{h+1});
    
    %Write fields
    for i=1:r
        for j=1:c
            fprintf(fid, '%8.0f\t%8.0f\t', i,j);            
            for h=3:length(header)-1
                fprintf(fid, '%8.2f\t', getfield(structure(i,j),header{h}));
            end
            % If you are on Windows OS change this line for the commented line
            fprintf(fid, '%8.2f\n', getfield(structure(i,j),header{h+1}));
        end
    end
    
    fclose(fid);
end
