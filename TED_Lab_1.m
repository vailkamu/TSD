%% 1. Загрузка данных

clc
clear all
close all

[t,rain,temp]=getweatherdatayr('http://www.yr.no/sted/Ukraina/Kiev/Kiev/varsel.xml');
% осадки измеряются в мм

% % --- При отсутствии интернета
% load([pwd,'\t.mat'])
% load([pwd,'\temp.mat'])
% load([pwd,'\rain.mat'])
% % ------


% ---- 2. Температура за ближайшее время ---

Temp_now=[temp(1,1); {datestr(t(1,1))}];
X=['Temperatura v Kieve na:',Temp_now(2,1),' scladaye: ',Temp_now(1,1)];

disp('____________________________________________________')
disp(X)

% ----- 3. Визуализация данных ---
hold on
figure(1)
plot(t,temp,'r'),
plot(t,rain,'g')
xlabel('Den`')
ylabel('Znachenie')
title('Grafik temperaturi ta opadiv zalegno vid dniv')
datetick('x','dd')

...

axis tight

legend({'Temperatura','Opadi'},'Location','NorthEast')

hold off

% ----- 4. Корреляция температуры и осадков ------

CorMas=[temp(1,:);rain(1,:)];
C=corrcoef(CorMas');

disp('____________________________________________________')
disp('Coef Corr:')
disp(C)

figure(2)
imagesc(C)
title('Cor all prices')
xlabel('temp')
ylabel('rain')

if C(1,2)&&C(2,1)==1
    disp('____________________________________________________')
    disp('Dannie ne correlityut!!!')
else
    disp('____________________________________________________')
    disp('Dannie crreliryut!!!')
end
% ----- 5. Преобразование данных ------

temperature=temp';
rain_t=rain';

for i=1:length(t)
DATE(i)={datestr(t(i))}; % На сайте формат температуры привязан к промежутку времени, напр 15:00-18:00, поэтому первый и второй элемент массива будет отражать температуру от 15:00 до 18:00, второй и третий температуру от 18:00-20:00.
end
disp('____________________________________________________')
T=table(temperature,rain_t,...
    'RowNames',DATE);
T(1:5,:)


% ----- 6. Расчет интервальной оценки центра распределения при неизвестной дисперсии -----

S_temp=std(temp);
S_rain=std(rain);
mean_temp=mean(temp);
mean_rain=mean(rain);
t_tab=abs(mean_temp-mean_rain)/sqrt((S_temp^2/length(temp))+(S_rain^2/length(rain)));

disp('____________________________________________________')
disp('Kol-vo elementov v massive:')
disp(length(temp))
disp('Tablichniy koef. Studenta pri alpha=0,95:')
disp(t_tab)

disp('____________________________________________________')
fprintf('Doveritelniy interval dlya temperatyri:%4.2d -%4.2d\n',mean_temp,2*S_temp)
fprintf('Doveritelniy interval dlya osadkov:%4.2d -%4.2d\n',mean_rain,2*S_rain)
disp('____________________________________________________')