#include <vulkan/vulkan.h>
#include <iostream>
 
int main(int argc, char* arv[])
{
    VkInstance instance;
    VkApplicationInfo appInfo {
        .sType              = VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pNext              = nullptr,
        .pApplicationName   = "Age editor",
        .applicationVersion = VK_MAKE_VERSION(1, 0, 0),
        .pEngineName        = "Age editor",
        .engineVersion      = VK_MAKE_VERSION(1, 0, 0),
        .apiVersion         = VK_API_VERSION_1_2
    };
    
    VkInstanceCreateInfo createInfo = {
        .sType                      = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .pNext                      = nullptr,
        .flags                      = 0,
        .pApplicationInfo           = &appInfo,
        .enabledLayerCount          = 0,
        .ppEnabledLayerNames        = nullptr,
        .enabledExtensionCount      = 0,
        .ppEnabledExtensionNames    = nullptr,
    };
    
    VkResult result = vkCreateInstance(&createInfo, nullptr, &instance);
    
    if (result == VK_SUCCESS)
    {
        std::cout << "Instance created successfully" << std::endl;
    }
    else 
    {
        std::cout << "Failed to create vulkan instance" << std::endl;
    }
    
    const char* names[] = { "bob", "fred" };
    std::string last_arg = names[3];
    
    return last_arg.size();
    
    return 0;
}