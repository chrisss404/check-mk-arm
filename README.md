
## Updates discontinued

Great news, there is an official commitment to add support for certain ARM architectures by Checkmk: [Checkmk – our road to ARM support](https://checkmk.com/blog/checkmk-our-road-arm-support).
This could mean, that at some point the Raspberry Pi 5 and subsequent models could use native Checkmk packages.
In the meantime, you can try [Zabbix](https://www.zabbix.com/download?os_distribution=raspberry_pi_os), it might even be the better choice anyway.

Unfortunately, due to native ARM support on the horizon we have decided to retire this project (thank you [@martux69](https://github.com/martux69) for all your hard work supporting arm64 over all the years).
This decision was based on the fact that keeping up with upstream changes has recently become increasingly time-consuming, additionally other (personal) things have become more important, so that there is no longer enough time.

There is a fork of the project that is being maintained on a "best effort" basis: https://github.com/FloTheSysadmin/check-mk-arm.
