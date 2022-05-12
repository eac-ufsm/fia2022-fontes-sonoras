function save_fig(Nome,mode,Fig,SavePdf,SavePng,SaveJpg,SaveFig,resolution,xaxis,fechar,append,extraSpace,render)
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Função para salvar facilmente figuras usando export_fig ou print.
%
%   Prof. William D'andrea Fonseca, Dr. Eng. - Acoustical Engineering
%
%   Last change: 01/10/2018
%
%   mode=1 para usar export_fig e mode=2 para usar print do Matlab
%   Se mode = ["1 ou 2" 1] silent mode se liga.
%
%   Exemplos:
%   save_fig(Nome,[1 1],Plot.fig,1,1,0,0,200,Plot.Tipo,0,0,0);
%   save_fig('Plot1',1,Plot.fig,1)
%   save_fig('Plot1',1,gcf,1,1)
%   save_fig
%   save_fig('Result1')
%   save_fig('Resultado','png')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input check
if ~exist('Nome','var') || isempty(Nome); Nome = ['Plot-' strrep(datestr(datetime('now')),':','-')]; Nome = strrep(Nome,' ','--');
elseif contains(Nome,':'); Nome = strrep(Nome,':','-'); end
if nargin<2; mode=1; Fig = gcf; SavePdf=1; SavePng=0; SaveFig=0; SaveJpg=0; resolution=200; xaxis=''; fechar=0; append=0; extraSpace=0; render='painters'; end
if nargin<3 && isnumeric(mode); Fig = gcf; SavePdf=1; SavePng=0; SaveFig=0; SaveJpg=0; resolution=200; xaxis=''; fechar=0; append=0; extraSpace=0; render='painters'; 
elseif nargin<3 && ~isnumeric(mode)
   resolution=200; xaxis=''; fechar=0; append=0; extraSpace=0; render='painters'; 
   if strcmp(mode,'pdf') || strcmp(mode,'PDF');     mode =1; Fig = gcf; SavePdf=1; SavePng=0; SaveJpg=0; SaveFig=0;
   elseif strcmp(mode,'png') || strcmp(mode,'PNG'); mode =1; Fig = gcf; SavePdf=0; SavePng=1; SaveJpg=0; SaveFig=0;
   elseif strcmp(mode,'jpg') || strcmp(mode,'JPG'); mode =1; Fig = gcf; SavePdf=0; SavePng=0; SaveJpg=1; SaveFig=0;
   elseif strcmp(mode,'fig') || strcmp(mode,'FIG'); mode =1; Fig = gcf; SavePdf=0; SavePng=0; SaveJpg=0; SaveFig=1;
   end
end
if ~exist('mode','var') || isempty(mode); mode=1; end
if length(mode)==2; silent=mode(2); mode=mode(1); else; silent=1; mode=mode(1); end
if ~(mode(1)==1 || mode(1)==2); mode(1)=1; disp('Tentarei usar export_fig e/ou o print do Matlab.'); end
if ~exist('Fig','var') || isempty(Fig); Fig = gcf; end
if exist('xaxis','var') && ~strcmp(xaxis,''); Nome = [Nome '-' xaxis]; end  
if ~exist('resolution','var'); resolution=200; end; if ~exist('fechar','var'); fechar=0; end
if ~exist('SavePdf','var'), SavePdf = 1; end; if ~exist('SavePng','var'), SavePng = 1; end
if ~exist('SaveJpg','var'), SaveJpg = 0; end; if ~exist('SaveFig','var'), SaveFig = 0; end 
if ~exist('append','var'), append = 0; end; if ~exist('render','var'), render = 'painters' ; end
%% Processa %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grava a figura em Matlab .fig.
if SaveFig == 1
   savefig(Fig,[Nome '.fig'],'compact');
end

% Usa export_fig
if mode==1 && exist('export_fig','file')==2
    disp('I using the export_fig function to save the figure(s).');    
if SavePdf == 1 && append == 0
   export_fig(Fig,sprintf('%s', Nome), '-pdf', ['-r' int2str(resolution)], '-q99', '-bookmark', '-transparent','-painters');
elseif SavePdf == 1 && append == 1
   export_fig(Fig,sprintf('%s', Nome), '-pdf', ['-r' int2str(resolution)], '-q99', '-append','-bookmark','-transparent', '-painters');
end
if SaveJpg == 1
   export_fig(Fig,sprintf('%s', Nome), '-jpg', ['-r' int2str(resolution)], '-q99');
end
if SavePng == 1
%    originalBack = get(Fig, 'color'); set(Fig, 'color', 'none'); %% Fundo tranparente
   export_fig(Fig,sprintf('%s', Nome), '-png', ['-r' int2str(resolution)], '-q99', '-transparent', ['-' render]);
%    set(Fig, 'color', originalBack); %% Refaz fundo original
end
elseif mode==1 && exist('export_fig','builtin')~=2
   disp('It seems the function ''export_fig'' is not installed, please have a look.')
   disp('I am going to use the Matlab ''print'' function.'); mode=2;
end 

% Usa o comando print do Matlab
if mode==2 
    disp('I am using the Matlab ''print'' function to save the figure(s).');
if SavePdf == 1 
% ax = Fig.CurrentAxes; fig = gcf; % set(fig, 'PaperUnits','centimeters'); 
set(Fig, 'Units','centimeters');
pos=get(Fig,'Position'); set(Fig, 'PaperSize', [pos(3) pos(4)]); % width = pos(3); height = pos(4);
if ~exist('extraSpace','var'); extraSpace=[0.03 0.03 0.03 0.03]; end       % [leftSpace, bottomSpace, rightSpace, topSpace] 
axisHandle = get(Fig, 'CurrentAxes'); set(axisHandle,'LooseInset',get(axisHandle,'TightInset') + extraSpace)
set(Fig, 'PaperPositionMode', 'manual'); set(Fig, 'PaperPosition',[0 0 pos(3) pos(4)]);    
   print(Fig,[Nome '.pdf'],'-painters',['-r' int2str(resolution)],'-dpdf');
end
if SaveJpg == 1
   print(Fig,[Nome '.jpg'],['-r' int2str(resolution)],'-djpeg');
end
if SavePng == 1
   set(gca,'color','none');
   print(Fig,[Nome '.png'],['-r' int2str(resolution)],'-dpng');
end
end


if fechar==1, close all; end
 if silent~=1; disp('Figure saved.'); end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EOF