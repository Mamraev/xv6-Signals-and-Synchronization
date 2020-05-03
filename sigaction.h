typedef unsigned int   uint;

struct sigaction {
  void (*sa_handler)(int);
  uint sigmask;
};
