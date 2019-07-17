function writeM2T(matrix,filename,header,fstr)
    
    if ~exist('matrix','var')
        error('no matrix')
    end;
    
    if ~exist('filename','var')
        error('no filename')
    end;
    
    if ~exist('header','var')
        error('no header')
    end;
    
     if ~exist('fstr','var')
        disp('default to %.2f')
        fstr='%.2f';
    end;
   
    
    [r c]  = size(matrix);
    if length(header) == c
        disp('using column headers');
         header = ['row',header];
         N=r;
    elseif length(header) == r
        disp('using row headers');
         header = ['col',header];
         N=c;
    else
        error('mismatch between length of header and size of matrix');
    end
        
    fid = fopen(filename, 'w');
     
    %Write header with fieldnames
    for h=1:length(header)-1
        fprintf(fid, '%s\t ',strtrim(header{h}));
    end
    % If you are on Windows OS change \n to \n\r
    fprintf(fid, '%s\n',strtrim(header{h+1}));
    
    %Write fields
    for i=1:N
        
        fprintf(fid, '%.0f\t', i);
        
        if header{1}=='row'
            
            for h=1:length(header)-2
                fprintf(fid, [fstr,'\t'], matrix(i,h));
            end
            % If you are on Windows OS change \n to \n\r
            fprintf(fid, [fstr,'\n'], matrix(i,h+1));
            
        else
            
            for h=1:length(header)-2
                fprintf(fid, [fstr,'\t'], matrix(h,i));
            end
            % If you are on Windows OS change \n to \n\r
            fprintf(fid, [fstr,'\n'], matrix(h+1,i));
            
        end

    end
    
    fclose(fid);
end
