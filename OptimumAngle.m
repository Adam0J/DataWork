[Theta,NegMaxDistance] = fminbnd(@MaxDistance,0,0.5*pi);
Theta %Optimum angle for furthest horizontal distance
HorizontalDistance = -NegMaxDistance %Furthest horizontal distance possible 