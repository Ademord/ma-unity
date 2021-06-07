﻿using System.IO;
using System.Linq;

namespace Alturos.Yolo
{
    public class ConfigurationDetector
    {
        public YoloConfiguration Detect(string path = @".\Config")
        {
            var files = this.GetYoloFiles(path);
            var yoloConfiguration = this.MapFiles(files);
            var configValid = this.AreValidYoloFiles(yoloConfiguration);

            if (configValid)
            {
                return yoloConfiguration;
            }

            throw new FileNotFoundException("Cannot found pre-trained model, check all config files available (.cfg, .weights, .names)");
        }

        private string[] GetYoloFiles(string path)
        {
            return Directory.GetFiles(path, "*.*", SearchOption.TopDirectoryOnly).Where(o => o.EndsWith(".names") || o.EndsWith(".cfg") || o.EndsWith(".weights")).ToArray();
        }

        private YoloConfiguration MapFiles(string[] files)
        {
            var configurationFile = files.Where(o => o.EndsWith(".cfg")).FirstOrDefault();
            var weightsFile = files.Where(o => o.EndsWith(".weights")).FirstOrDefault();
            var namesFile = files.Where(o => o.EndsWith(".names")).FirstOrDefault();

            return new YoloConfiguration(configurationFile, weightsFile, namesFile);
        }

        private bool AreValidYoloFiles(YoloConfiguration config)
        {
            if (string.IsNullOrEmpty(config.ConfigFile) ||
                string.IsNullOrEmpty(config.WeightsFile) ||
                string.IsNullOrEmpty(config.NamesFile))
            {
                return false;
            }

            return true;
        }
    }
}
