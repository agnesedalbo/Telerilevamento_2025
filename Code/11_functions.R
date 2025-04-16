# Code to build your own functions

somma <- function(x,y) {
  z=x+y
  return(z)
  }

pannellone <- function(x,y) {
  par(mfrow=c(x,y)
}
      
# Exercise: make a new function called differenza

differenza <- function(x,y) {
  z=x-y
  return(y)
}

positivo <- function(x) {
  if(x>0) {
    print("Questo numero è positivo")
   }
  else if(x<0) {
    print("Questo numero è negativo")
    }
  else if(x=0) {
    print("Lo zero non è nè positivo nè negativo")
  }
}


positivo <- function(x) {
  if(x>0) {
    print("Questo numero è positivo")
   }
  else if(x<0) {
    print("Questo numero è negativo")
    }
  else {
    print("Lo zero non è nè positivo nè negativo")
  }
}

flipint <- function(x) {
  x = flip(x)
  plot(x)
}
      
