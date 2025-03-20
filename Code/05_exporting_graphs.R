# This code helps exporting graphs to images 

# Exporting data
setwd("C:\\utente\Downloads") 
setwd("C://utente/Downloads") 
setwd("/users/magda/Documents")
# Windowds users: C://comp/Downloads
# \
# setwd("C://nome/Downloads")

getwd()

pdf("output.pdf")
plot(grdif)
dev.off()

jpeg("output.jpeg")
plot(grdif)
dev.off()
