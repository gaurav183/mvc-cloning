function [lambdas] = MVC(x,y,dP)
	[m, ~] = size(dP);
    lambdas = zeros(1,m);
    for i=1:m      
      % distance of x and p_i = dist_xp
      dist_xp = ((dP(i,1) - x)^2 + (dP(i,2) - y)^2)^0.5;
      % distance of x and p_i+1 => dist_xp1
      % distance of x and p_i-1 => dist_x1p
      % distance of p_i-1 and p => dist_1pp
      % distance of p and p_i+1 => dist_pp1
      if (i == m)
      	dist_xp1 = ((dP(1,1) - x)^2 + (dP(1,2) - y)^2)^0.5;
        dist_x1p = ((dP(i-1,1) - x)^2 + (dP(i-1,2) - y)^2)^0.5;
        dist_pp1 = ((dP(i,1) - dP(1,1))^2 + (dP(i,2) - dp(1,2))^2)^0.5;
        dist_1pp = ((dP(i-1,1) - dP(i,1))^2 + (dP(i-1,2) - dp(i,2))^2)^0.5;
      elseif (i == 1)
      	dist_x1p = ((dP(m,1) - x)^2 + (dP(m,2) - y)^2)^0.5;
      	dist_xp1 = ((dP(i+1,1) - x)^2 + (dP(i+1,2) - y)^2)^0.5;
        dist_pp1 = ((dP(i,1) - dP(i+1,1))^2 + (dP(i,2) - dp(i+1,2))^2)^0.5;
        dist_1pp = ((dP(m,1) - dP(i,1))^2 + (dP(m,2) - dp(i,2))^2)^0.5;
      else
      	dist_x1p = ((dP(i-1,1) - x)^2 + (dP(i-1,2) - y)^2)^0.5;
      	dist_xp1 = ((dP(i+1,1) - x)^2 + (dP(i+1,2) - y)^2)^0.5;
        dist_pp1 = ((dP(i,1) - dP(i+1,1))^2 + (dP(i,2) - dp(i+1,2))^2)^0.5;
        dist_1pp = ((dP(i-1,1) - dP(i,1))^2 + (dP(i-1,2) - dp(i,2))^2)^0.5;
      end
      
      
      cos_alpha = (dist_xp1^2 + dist_xp^2 - dist_pp1^2)/(2*dist_xp*dist_xp1);
      cos_prevAlpha = (dist_x1p^2 + dist_xp^2 - dist_1pp^2)/(2*dist_xp*dist_x1p);
      
      %currently in radians
      alpha = acos(cos_alpha);
      prevAlpha = acos(cos_prevAlpha);
      wi = (tan(prevAlpha/2) + tan(alpha/2)) / diff;
      lambdas(i) = wi;
    end
    
    total = sum(lambdas);
    lambdas = lambdas / total;
    
end