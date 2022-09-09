#include <poll.h>
#include <libudev.h>
#include <stdexcept>
#include <iostream>
// https://stackoverflow.com/questions/34804423/qt-dbus-not-receiving-signals
// https://stackoverflow.com/questions/22592042/qt-dbus-monitor-method-calls

udev* hotplug;
udev_monitor* hotplug_monitor;

void init()
{
  // create the udev object
    hotplug = udev_new();
    if(!hotplug)
    {
    throw std::runtime_error("cannot create udev object");
    std::cout << "not created" << std::endl;
    }

    // create the udev monitor
    hotplug_monitor = udev_monitor_new_from_netlink(hotplug, "udev");
    // int ret = udev_monitor_filter_add_match_subsystem_devtype(hotplug_monitor,
    //                                 "usb",
    //                                 "usb_device");
    // int ret1 = udev_monitor_filter_add_match_subsystem_devtype(hotplug_monitor,
    //                                 "drm",
    //                                 "drm_minor");
                                    // drm_minor
    // start receiving hotplug events
    udev_monitor_enable_receiving(hotplug_monitor);
    std::cout << "initialized \n";
}

void deinit()
{
  // destroy the udev monitor
  udev_monitor_unref(hotplug_monitor);

  // destroy the udev object
  udev_unref(hotplug);
}

void run()
{
  // create the poll item
    pollfd items[1];
    items[0].fd = udev_monitor_get_fd(hotplug_monitor);
    items[0].events = POLLIN ;
    items[0].revents = POLLHUP;
    std::cout << "srun" << std::endl;
  // while there are hotplug events to process
    while(1){
        if (poll(items, 1, 50) > 0) {
            std::cout << "Event hotplug[ " << items[0].revents << " ]" << std::endl;

        // receive the relevant device
            udev_device* dev = udev_monitor_receive_device(hotplug_monitor);
            if(!dev)
            {
                std::cout << "error " << std::endl;
                continue;
            }


            std::cout << "hotplug[" << udev_device_get_action(dev) << "] ";
            std::cout << udev_device_get_subsystem(dev) << ",";
            std::cout << udev_device_get_syspath(dev) << ",";
            std::cout << udev_device_get_devnode(dev) << ",";
            std::cout << udev_device_get_devpath(dev) << ",";
            std::cout << udev_device_get_devtype(dev) << std::endl;
            
            struct udev_list_entry *list_entry;
            udev_list_entry_foreach(list_entry, udev_device_get_properties_list_entry(dev)) {
                    if (!udev_list_entry_get_name(list_entry))
                            continue;
                    printf("E:%s=%s\n",
                udev_list_entry_get_name(list_entry),
                udev_list_entry_get_value(list_entry));
            }
            // destroy the relevant device
            udev_device_unref(dev);

            // XXX
            std::cout << "done" << std::endl;
        }
    }
}

int main () {
    init();
    run();
    return 0;
}