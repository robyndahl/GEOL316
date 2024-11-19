# this script contains several functions written by Andrew Zaffos for his
# Velociraptr package, which no longer runs smoothly in R
# the original Velociraptr repositor can be found here:
# https://github.com/paleobiodb/analysis_tools/tree/master/velociraptr

# run this entire script to load all the functions

# download time function
downloadTime<-function(Timescale="interational epochs") {
  Timescale<-gsub(" ","%20",Timescale)
  URL<-paste0("https://macrostrat.org/api/v2/defs/intervals?format=csv&timescale=",Timescale)
  Intervals<-utils::read.csv(URL,header=TRUE)
  Midpoint<-apply(Intervals[,c("t_age","b_age")],1,stats::median)
  Intervals<-cbind(Intervals,Midpoint)
  rownames(Intervals)<-Intervals[,"name"]
  return(Intervals)
}

# constrain ages
constrainAges<-function(Data,Timescale) {
  Data[,"early_interval"]<-as.character(Data[,"early_interval"])
  Data[,"late_interval"]<-as.character(Data[,"late_interval"])
  for (i in 1:nrow(Timescale)) {
    EarlyPos<-which(Data[,"max_ma"]>Timescale[i,"t_age"] & Data[,"max_ma"]<=Timescale[i,"b_age"])
    Data[EarlyPos,"early_interval"]<-as.character(Timescale[i,"name"])
    LatePos<-which(Data[,"min_ma"]>=Timescale[i,"t_age"] & Data[,"min_ma"]<Timescale[i,"b_age"])
    Data[LatePos,"late_interval"]<-as.character(Timescale[i,"name"])
  }
  Data<-Data[Data[,"early_interval"]==Data[,"late_interval"],] # Remove taxa that range through
  return(Data)
}

# presence matrix
presenceMatrix<-function(Data,Rows="geoplate",Columns="genus") {
  FinalMatrix<-matrix(0,nrow=length(unique(Data[,Rows])),ncol=length(unique(Data[,Columns])))
  rownames(FinalMatrix)<-unique(Data[,Rows])
  colnames(FinalMatrix)<-unique(Data[,Columns])
  ColumnPositions<-match(Data[,Columns],colnames(FinalMatrix))
  RowPositions<-match(Data[,Rows],rownames(FinalMatrix))
  Positions<-cbind(RowPositions,ColumnPositions)
  FinalMatrix[Positions]<-1
  return(FinalMatrix)
}

# cull the matrix
cullMatrix <- function(CommunityMatrix,Rarity=2,Richness=2,Silent=FALSE) {
  if (Silent==TRUE) {
    FinalMatrix<-softCull(CommunityMatrix,MinOccurrences=Rarity,MinRichness=Richness)
  }
  else {
    FinalMatrix<-errorMatrix(CommunityMatrix,MinOccurrences=Rarity,MinRichness=Richness)
  }
  return(FinalMatrix)
}

# Steve Holland's Culling Functions
errorMatrix <- function(CommunityMatrix, MinOccurrences=2, MinRichness=2) {
  FinalMatrix <- CommunityMatrix
  while (diversityFlag(FinalMatrix, MinRichness) | occurrencesFlag(FinalMatrix, MinOccurrences)) {
    FinalMatrix <- cullTaxa(FinalMatrix, MinOccurrences)
    FinalMatrix <- cullSamples(FinalMatrix, MinRichness)
  }
  return(FinalMatrix)
}

# Dependency of cullMatrix()
cullTaxa <- function(CommunityMatrix, MinOccurrences) {
  PA <- CommunityMatrix
  PA[PA>0] <- 1
  Occurrences <- apply(PA, MARGIN=2, FUN=sum)
  AboveMinimum <- Occurrences >= MinOccurrences
  FinalMatrix <- CommunityMatrix[ ,AboveMinimum]
  if (length(FinalMatrix)==0) {print("no taxa left!")}
  return(FinalMatrix)
}

# Dependency of cullMatrix()
cullSamples <- function(CommunityMatrix, MinRichness) {
  PA <- CommunityMatrix
  PA[PA>0] <- 1
  Richness <- apply(PA, MARGIN=1, FUN=sum)
  AboveMinimum <- Richness >= MinRichness
  FinalMatrix <- CommunityMatrix[AboveMinimum, ]
  if (length(FinalMatrix[,1])==0) {print("no samples left!")}
  return(FinalMatrix)
}

# Dependency of cullMatrix()
occurrencesFlag <- function(CommunityMatrix, MinOccurrences) {
  PA <- CommunityMatrix
  PA[PA>0] <- 1
  Occurrences <- apply(PA, MARGIN=2, FUN=sum)
  if (min(Occurrences) < MinOccurrences) {
    Flag <- 1
  }
  else {
    Flag <- 0
  }
  return(Flag)
}

# Dependency of cullMatrix()
diversityFlag <- function(CommunityMatrix, MinRichness) {
  PA <- CommunityMatrix
  PA[PA>0] <- 1
  Richness <- apply(PA, MARGIN=1, FUN=sum)
  if (min(Richness) < MinRichness) {
    Flag <- 1
  }
  else {
    Flag <- 0
  }
  return(Flag)
}

# Alternative to cullMatrix( ) that does not thrown an error, but returns a single NA
softCull <- function(CommunityMatrix, MinOccurrences=2, MinRichness=2) {
  NewMatrix <- CommunityMatrix
  while (diversityFlag(NewMatrix, MinRichness) | occurrencesFlag(NewMatrix, MinOccurrences)) {
    NewMatrix <- softTaxa(NewMatrix, MinOccurrences)
    if (length(NewMatrix)==1) {
      return(NA)
    }
    NewMatrix <- softSamples(NewMatrix, MinRichness)
    if (length(NewMatrix)==1) {
      return(NA)
    }
  }
  return(NewMatrix)
}

# Dependency of softCull()
softTaxa <- function(CommunityMatrix, MinOccurrences) {
  PA <- CommunityMatrix
  PA[PA>0] <- 1
  Occurrences <- apply(PA, MARGIN=2, FUN=sum)
  AboveMinimum <- Occurrences >= MinOccurrences
  FinalMatrix <- CommunityMatrix[ ,AboveMinimum]
  if (length(FinalMatrix)==0) {
    FinalMatrix<-NA;
    return(NA)
  }
  return(FinalMatrix)
}

# Dependency of softCull()
softSamples <- function(CommunityMatrix, MinRichness) {
  PA <- CommunityMatrix
  PA[PA>0] <- 1
  Richness <- apply(PA, MARGIN=1, FUN=sum)
  AboveMinimum <- Richness >= MinRichness
  FinalMatrix <- CommunityMatrix[AboveMinimum, ]
  if (length(FinalMatrix[,1])==0) {
    FinalMatrix<-NA;
    return(NA)
  }
  return(FinalMatrix)
}