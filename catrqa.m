function [out] = catrqa(rp,DLmin,VLmin,HLmin,DLmax,VLmax,HLmax)
    
    % Input should be a matrix of zeroes and ones, output is a structure
    
    % Some crude input diagnostics:
    % The field nozero indicates there were no zeroes in the RP
    % The field noone indicates there were no ones in the RP
    % The field more2 indicates there were more than 2 unique values in the RP -> values>0 are changed to 1
    
    % Some crude error handling:
    % If dl or tt (from Marwan's toolbox) yield a NaN result:
    %  all output based on those line distributions will be returned as NaN
    
    if ~exist('rp','var')||isempty(rp),
        error('no data in recurrence matrix')
    end;
    
    if ~exist('DLmin','var')
        DLmin=2;
    end;
    
    if ~exist('VLmin','var')
        VLmin=2;
    end;
    
    if ~exist('HLmin','var')
        HLmin=2;
    end;
    
    freq_rp = tabulate(rp(:));
    
    more2   = false;
    nozero  = false;
    noone   = false;
    
    if length(freq_rp(:,1))>2
        disp(['WARNING: More than 2 unique values found in RP: ',num2str(freq_rp(:,1))']);
        more2 = true;
    end
    
     if isempty(find(freq_rp(:,1)==1, 1))
        disp(['WARNING: There are no 1-elements in RP matrix...']);
        noone = true;
    end
   
    
    if isempty(find(freq_rp(:,1)==0, 1))
        disp('WARNING: There are no 0-elements in RP matrix...');
        nozero = true;
    end
    
    %To do: offer automatic solution
    if nozero
        disp('No zeroes means everything is recurring!');
        disp('Try changing the most often occurring value to 0:');
        disp('Value       Freq      Percent');
        disp(num2str(freq_rp));
    end
    
    if more2||noone
        disp('Converting ~=0 to 1');
        [rpr,rpc]=find(rp);
        rp(rpr,rpc)=1;
    end
    
    %CRQA Measures
    
    %Calculate size of RP
    [RP_m RP_n] = size(rp);
    RP_size = RP_m.*RP_n;
    
    %Total # recurrent points
    TR = nnz(rp);
    
    %Proportion recurrence / Recurrence Rate
    RR = TR/RP_size;
    
    %Meanline, TT, TT_h TT_v and distributions of line lengths -> using Marwan's Toolbox
    [MEAN_dl dist_dl] = dl(rp );
    [  TT_vl dist_vl] = tt(rp );
    [  TT_hl dist_hl] = tt(rp');
    
    dlNAN=false;vlNAN=false;hlNAN=false;
    if isnan(dist_dl) dist_dl=[0; 1; 2]; dlNAN=true; end
    if isnan(dist_vl) dist_vl=[0; 1; 2]; vlNAN=true; end
    if isnan(dist_hl) dist_hl=[0; 1; 2]; hlNAN=true; end
       
    %Frequency tables of line lengths
    freq_dl = tabulate(dist_dl);
    freq_vl = tabulate(dist_vl);
    freq_hl = tabulate(dist_hl);
    
    %Maximum line lengths if not passed as variable
    if ~exist('DLmax','var')
        if freq_dl(end,1)<min([RP_m RP_n])
            DLmax = freq_dl(end,1);
        else
            DLmax = min([RP_m RP_n]);
        end
    end;
    
    if ~exist('VLmax','var')
        if freq_vl(end,1)<RP_m
            VLmax=freq_vl(end,1);
        else
            VLmax=RP_m;
        end
    end;
    
    if ~exist('HLmax','var')
        if freq_hl(end,1)<RP_n
            HLmax=freq_hl(end,1);
        else
            HLmax=RP_n;
        end
    end;
        
    %Number of recurrent points on diagonal, vertical and horizontal lines
    N_dl = sum(freq_dl(DLmin:DLmax,2).*freq_dl(DLmin:DLmax,1));
    N_vl = sum(freq_vl(VLmin:VLmax,2).*freq_vl(VLmin:VLmax,1));
    N_hl = sum(freq_hl(HLmin:HLmax,2).*freq_hl(HLmin:HLmax,1));
    
    %Determinism / Horizontal and Vertical Laminarity
    DET    = N_dl/TR;
    LAM_vl = N_vl/TR;
    LAM_hl = N_hl/TR;
    
    %Array of probabilities that a certain line length will occur (all >1)
    P_dl = nonzeros(freq_dl(DLmin:DLmax,2)./sum(freq_dl(DLmin:DLmax,2)));
    P_vl = nonzeros(freq_vl(VLmin:VLmax,2)./sum(freq_vl(VLmin:VLmax,2)));
    P_hl = nonzeros(freq_hl(HLmin:HLmax,2)./sum(freq_hl(HLmin:HLmax,2)));
    
    %Entropy of line length distributions
    ENT_dl=-1*sum(P_dl.*log(P_dl));
    ENT_vl=-1*sum(P_vl.*log(P_vl));
    ENT_hl=-1*sum(P_hl.*log(P_hl));
    
    %Relative Entropy (Entropy / Max entropy)
    ENTrel_dl = ENT_dl/(-1*log(1/DLmax));
    ENTrel_vl = ENT_vl/(-1*log(1/VLmax));
    ENTrel_hl = ENT_hl/(-1*log(1/HLmax));
    
    %Maxline
    MAX_dl = max(dist_dl);
    MAX_vl = max(dist_vl);
    MAX_hl = max(dist_hl);
    
    %Divergence
    DIV_dl = 1/MAX_dl;
    DIV_vl = 1/MAX_vl;
    DIV_hl = 1/MAX_hl;
     
    %Output
    out.TR        = TR;
    out.RR        = RR;
     
    if dlNAN
        out.DET       = NaN;
        out.MEAN_dl   = NaN;
        out.MAX_dl    = NaN;
        out.DIV_dl    = NaN;
        out.ENT_dl    = NaN;
        out.ENTrel_dl = NaN;
    else
        out.DET       = DET;
        out.MEAN_dl   = MEAN_dl;
        out.MAX_dl    = MAX_dl;
        out.DIV_dl    = DIV_dl;
        out.ENT_dl    = ENT_dl;
        out.ENTrel_dl = ENTrel_dl;
    end
    
    if vlNAN
        out.LAM_vl    = NaN;
        out.TT_vl     = NaN;
        out.MAX_vl    = NaN;
        out.DIV_vl    = NaN;
        out.ENT_vl    = NaN;
        out.ENTrel_vl = NaN;
    else
        out.LAM_vl    = LAM_vl;
        out.TT_vl     = TT_vl;
        out.MAX_vl    = MAX_vl;
        out.DIV_vl    = DIV_vl;
        out.ENT_vl    = ENT_vl;
        out.ENTrel_vl = ENTrel_vl;
    end
    
    if hlNAN
        out.LAM_hl    = NaN;
        out.TT_hl     = NaN;
        out.MAX_hl    = NaN;
        out.DIV_hl    = NaN;
        out.ENT_hl    = NaN;
        out.ENTrel_hl = NaN;
    else
        out.LAM_hl    = LAM_hl;
        out.TT_hl     = TT_hl;
        out.MAX_hl    = MAX_hl;
        out.DIV_hl    = DIV_hl;
        out.ENT_hl    = ENT_hl;
        out.ENTrel_hl = ENTrel_hl;
    end
    
    out.nozero    = nozero;
    out.noone     = noone;
    out.more2     = more2;
    
end