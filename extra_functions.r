#Created by Esteban.
# Thu Feb 12

#' @title getLW
#'
#' @description
#' Simplifies a complex geometry as length and width maintaining the area and
#' perimeter of the original geometry. 
#'
#' @param A geometry area
#' @param P geometry perimeter
#' @param tl (optional, default = 0.1) tolerance level for the approximation
#' @return c(l, w)
#' @examples
#' @author M. Estebna Munoz H.
getLW <- function(A, P, tl=0.1){
    w.p = P/4
    l.p = P/4

    Ao = w.p * l.p

    if((A-Ao) > 0){
        tl <- -tl
    }else if((A-Ao) == 0){
        return(c(w.p, l.p))
    }

    foundOne <- TRUE
    i = 0
    difference = Inf
    while(foundOne){
        i = i+1
        w.p = w.p + tl
        l.p = (P - 2*w.p)
        Ai = l.p * w.p
        if(abs(A-Ai) < difference){
            difference <- abs(A-Ai)
        }else{
            foundOne = FALSE
        }
    }
    return(c(w.p, l.p))
}
