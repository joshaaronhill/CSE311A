int: w = 23;
int: h = 9;

set of int: times = 0..w;
set of int: apps = 0..h;
array[times, apps] of var bool: t;

constraint sum (i in times)(t[i,0]) = 24; %refrig tot
constraint sum (i in times)(t[i,1]) = 6; %veh tot
constraint sum (i in times)(t[i,2]) = 1; %wash tot
constraint sum (i in times)(t[i,3]) = 1; %dry tot
constraint sum (i in times)(t[i,4]) = 4; %vac tot
constraint sum (i in times)(t[i,5]) = 3; %game tot
constraint sum (i in times)(t[i,6]) = 2; %tv tot
constraint sum (i in times)(t[i,7]) = 2; %ov tot

constraint sum (i in 0..8)(t[i,1]) = 6; %veh times
constraint sum (i in 9..16)(t[i,2]) = 1; %wash times
constraint sum (i in 9..16)(t[i,3]) = 1; %dry times
constraint sum (i in 9..16)(t[i,4]) = 4; %vac times
constraint sum (i in 18..23)(t[i,5]) = 3; %game times
constraint sum (i in 18..23)(t[i,6]) = 2; %tv times
constraint sum (i in 17..18)(t[i,7]) = 2; %ov times

%I realize that some of these constraints cause "Array access out of bounds" warnings
%In Minizinc, failed array accesses return "False" (or the value 0) which works just fine for my conditions
%I don't see a reason to fix it

constraint forall(i in times)(t[i,3] = 1 -> sum(j in 0..i-1)(t[j, 2]) = 1); %wash + dry
constraint forall(i in times)(t[i,5] = 1 -> (t[i-1, 5] + t[i+1, 5] >= 1)); %game consec
constraint forall(i in times)(t[i,6] = 1 -> (t[i-1, 6] + t[i+1, 6] >= 1)); %tv consec
constraint forall(i in times)(t[i,6] + t[i, 5] != 2); %tv + game
constraint forall(i in times)(t[i,7] = 1 -> (t[i-1, 7] + t[i+1, 7] >= 1)); %ov consec
constraint forall(i in times)(t[i,8] = (t[i, 5] + t[i,6] + t[i, 7] >= 1)); %lights
constraint forall(i in times)(t[i,9] = t[i, 7]); %radio

array[times] of float: p = array1d(times, [0.198,0.198,0.198,0.198,0.198,0.198,0.198,0.198,0.198,0.225,0.225,0.225,0.249,0.249,0.849,0.849,0.849,0.849,0.225,0.225,0.225,0.198,0.198,0.198]);

array[apps] of float: k = array1d(apps, [3.25, 5.0,0.30,2.5,0.20,1.75,1.5,0.70,0.33,0.10]);

solve minimize sum(i in times, j in apps)(t[i,j]*p[i]*k[j]);

output ["t: "]++["\(i)" ++ "\t" | i in times]++
      ["\nf: "]++[show(t[i,0]) ++ "\t" | i in times]++
      ["\ne: "]++[show(t[i,1]) ++ "\t" | i in times]++
      ["\nw: "]++[show(t[i,2]) ++ "\t" | i in times]++
      ["\nd: "]++[show(t[i,3]) ++ "\t" | i in times]++
      ["\nv: "]++[show(t[i,4]) ++ "\t" | i in times]++
      ["\ng: "]++[show(t[i,5]) ++ "\t" | i in times]++
      ["\nt: "]++[show(t[i,6]) ++ "\t" | i in times]++
      ["\no: "]++[show(t[i,7]) ++ "\t" | i in times]++
      ["\nl: "]++[show(t[i,8]) ++ "\t" | i in times]++
      ["\nr: "]++[show(t[i,9]) ++ "\t" | i in times]++
      ["\nf-usage: "]++[show(sum(i in times)(t[i, 0]*k[0]))]++
      ["\ne-usage: "]++[show(sum(i in times)(t[i, 1]*k[1]))]++
      ["\nw-usage: "]++[show(sum(i in times)(t[i, 2]*k[2]))]++
      ["\nd-usage: "]++[show(sum(i in times)(t[i, 3]*k[3]))]++
      ["\nv-usage: "]++[show(sum(i in times)(t[i, 4]*k[4]))]++
      ["\ng-usage: "]++[show(sum(i in times)(t[i, 5]*k[5]))]++
      ["\nt-usage: "]++[show(sum(i in times)(t[i, 6]*k[6]))]++
      ["\no-usage: "]++[show(sum(i in times)(t[i, 7]*k[7]))]++
      ["\nl-usage: "]++[show(sum(i in times)(t[i, 8]*k[8]))]++
      ["\nr-usage: "]++[show(sum(i in times)(t[i, 9]*k[9]))]++
      ["\nf-cost: "]++[show(sum(i in times)(t[i, 0]*p[i]*k[0]))]++
      ["\ne-cost: "]++[show(sum(i in times)(t[i, 1]*p[i]*k[1]))]++
      ["\nw-cost: "]++[show(sum(i in times)(t[i, 2]*p[i]*k[2]))]++
      ["\nd-cost: "]++[show(sum(i in times)(t[i, 3]*p[i]*k[3]))]++
      ["\nv-cost: "]++[show(sum(i in times)(t[i, 4]*p[i]*k[4]))]++
      ["\ng-cost: "]++[show(sum(i in times)(t[i, 5]*p[i]*k[5]))]++
      ["\nt-cost: "]++[show(sum(i in times)(t[i, 6]*p[i]*k[6]))]++
      ["\no-cost: "]++[show(sum(i in times)(t[i, 7]*p[i]*k[7]))]++
      ["\nl-cost: "]++[show(sum(i in times)(t[i, 8]*p[i]*k[8]))]++
      ["\nr-cost: "]++[show(sum(i in times)(t[i, 9]*p[i]*k[9]))]++
      ["\ntotal-cost: "]++[show(sum(i in times, j in apps)(t[i,j]*p[i]*k[j]))];