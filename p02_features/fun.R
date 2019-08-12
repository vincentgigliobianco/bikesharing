super_maestro = function(filename){
  
  source("cleaning.R", encoding = "UTF-8")
  source("features.R", encoding = "UTF-8")
  root = "../p03_exploration/shiny_app/"
  rootcsv = "../p04_model/data/"
  file = strsplit(x = filename,split = ".",fixed = T)[[1]][1]
  pathfile = paste0(root,file,".rds")
  pathfilecsv = paste0(rootcsv,file,".csv")
  
  # On supprime les fake variables s'il s'agit de test
  if(filename == "test.csv"){
    df$casual = NULL
    df$casualQ = NULL
    df$registered = NULL
    df$registeredQ = NULL
    df$count = NULL
  }
  
  saveRDS(object = df,file = pathfile)
  write.csv(x = df,file = pathfilecsv,row.names = F)
  
}


fun_modify_script_py = function(filename){
  
  myscript <- readLines("~/proj/bikesharing/p01_import/import_and_cleaning.py")
  old_target = "df = pd.read_csv(\"../data/train.csv\")" 
  
  if (filename=="test.csv") {
    new_target = "df = pd.read_csv(\"../data/test.csv\")" } else {
      new_target = old_target
    }
  
  final_script = sapply(myscript,function(l){gsub(old_target, new_target, l,fixed = T)})
  names(final_script) = NULL
  fileConn<-file("~/proj/bikesharing/p01_import/import_and_cleaning.py")
  writeLines(final_script, fileConn)
  close(fileConn)
  
}