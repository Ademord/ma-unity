def main():
    import settings, os
    settings.settings_controller.initialize(os.getcwd() + "/")

    import trainer
    m_Trainer = trainer.Trainer(settings.callback)

    # m_Trainer.test_compatibility()
    m_Trainer.model_pipeline()

    settings.settings_controller.close_all()


if __name__ == '__main__':
    main()
