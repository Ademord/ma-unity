def main():
    import settings
    settings.initialize()

    import trainer
    m_Trainer = trainer.Trainer(settings.callback)

    # m_Trainer.test_compatibility()
    m_Trainer.model_pipeline()

    settings.close_all()


if __name__ == '__main__':
    main()
