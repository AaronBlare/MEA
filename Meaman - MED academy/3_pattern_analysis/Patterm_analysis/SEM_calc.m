function sem=SEM_calc(vect  )

sem = ( (nanstd(vect)) ./ sqrt(sum(~isnan(vect))) )