#include <stdio.h>
#include <fcntl.h>
#include <linux/input.h>
#include <string.h>
#include <unistd.h>
#include <sys/poll.h>

#define DEVICES "/proc/bus/input/devices"
#define MAX_NFD 4
#define LENGTH(X) (sizeof X / sizeof X[0])
#define DEVICE_TYPES "Keyboard", "keyboard", "Lid", "Sleep", "Power"
const char *SEARCH_TERMS[] = { DEVICE_TYPES };

typedef struct
{
  unsigned nfd, count;
  char DEV[MAX_NFD][32];
} device_t;



static void parse_dev_cb(void *data, char LINE[])
{
  device_t *device = (device_t *)data;
  if (!strncmp("N:", LINE, 2))
  {
    for (unsigned i = 0; i < LENGTH(SEARCH_TERMS); i++)
      if (strstr(LINE, SEARCH_TERMS[i]))
        device->nfd++;
  }

  else if (!strncmp("H:", LINE, 2) && device->count < device->nfd)
  {
    char *p;
    if ((p = strstr(LINE, "event")))
    {
      char EV[7];
      sscanf(p, "%s", EV);
      sprintf(device->DEV[device->nfd - 1], "/dev/input/%s", EV);
      device->count++;
    }
  }
}

static void read_file(void *data, const char FILENAME[])
{
  FILE *fp = fopen(FILENAME, "r");
  if (!fp)
    return;

  char LINE[256];
  while (fgets(LINE, sizeof LINE, fp))
    parse_dev_cb(data, LINE);

  fclose(fp);
}
int main(int argc, char **argv)
{
  device_t device = { 0 };
  read_file(&device, DEVICES);
  unsigned NFD = device.nfd;
  struct pollfd PFD[NFD];

  for (unsigned i = 0; i < NFD; i++)
  {
    PFD[i].fd = open(device.DEV[i], O_RDONLY);
    PFD[i].events = POLLIN;
  }
  
  struct input_event evt;
  while (1)
  {
    poll(PFD, NFD, -1);
    for (int i = 0; i < NFD; i++)
      if (PFD[i].revents & POLLIN)
      {
        read(PFD[i].fd, &evt, sizeof evt);

        if (!evt.value);
        else if (evt.type == EV_SW)
        {
            //  && (evt.code == SW_LID | evt.code == 0x01
          printf("Lid event %d\n", evt.code);
        }
        else if (evt.type == EV_KEY && evt.code == KEY_BRIGHTNESSUP)
        {
          printf("Brightess Up event\n");
        }
        else if (evt.type == EV_KEY && evt.code == KEY_BRIGHTNESSDOWN)
        {
          printf("Brightness Down event\n");
        }
        else if (evt.type == EV_KEY && evt.code == KEY_SLEEP)
        {
          printf("Sleep event\n");
        }
        else if (evt.type == EV_KEY && evt.code == KEY_POWER)
        {
          printf("Power event\n");
        }
      }
  }
  
  for (unsigned i = 0; i < NFD; i++)
    close(PFD[i].fd);
}