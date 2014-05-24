### SHELL> mpiexec -np 2 Rscript --vanilla [...]_rmpi.r

library(Rmpi)
invisible(mpi.comm.dup(0, 1))

source("./01_setting")

x.total <- N * .comm.size
x <- (1:N) + N * .comm.rank

time.proc <- list()

time.proc$Robj <- system.time({
  for(i in 1:iter.total){
    y <- mpi.gather.Robj(matrix(x, nrow = sqrt(N)))
  }
  invisible(mpi.barrier())
})

time.proc$integer <- system.time({
  for(i in 1:iter.total){
    y <- mpi.gather(as.integer(x), 1, integer(x.total))
  }
  invisible(mpi.barrier())
})

time.proc$double <- system.time({
  for(i in 1:iter.total){
    y <- mpi.gather(as.double(x), 2, double(x.total))
  }
  invisible(mpi.barrier())
})

if(.comm.rank == 0){
  print(time.proc)
}

mpi.quit()
