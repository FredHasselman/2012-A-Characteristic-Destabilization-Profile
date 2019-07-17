%% Fred's UTILS: Grab the current figure window and print to EPS file
%
% Use: grab('filename',closeit);
%
%  'filename': Name of file to save | if omitted name will be current date and time
%  closeit   : [0] does not close fig. | [1] closes fig. {default}
%
%
% Fred Hasselman - Februari 2011

function grab(name,closeit)
    
    % Check arguments
    error(nargchk(0, 2, nargin));
    error(nargchk(0, 0, nargout));
    if nargin < 2;closeit = 1; end
    if nargin < 1;name=datestr(now);name=name(name~=isspace(name));end
    
    ext='.eps';
    fname=[name ext];
    
    % Print to EPS (if there is a figure)
    h=findobj;
    if h==0
        disp('No figure to print?')
    else
        shg;
        set(gcf, 'PaperPositionMode', 'auto')
        print('-depsc2',fname)
        if closeit==1
            close;
        end
        disp(['Current figure saved as: ' fname]);       
    end
    
end